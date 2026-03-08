import 'dart:convert';

import 'package:drift/drift.dart';

import '../../models/models.dart' as models;
import 'app_database.dart';

/// Datasource for item and field value CRUD operations.
class ItemLocalDataSource {
  final AppDatabase _db;

  ItemLocalDataSource(this._db);

  // ── Items ──────────────────────────────────────────────────

  /// Watch all items in a collection, ordered by updatedAt desc.
  Stream<List<models.Item>> watchItemsByCollection(String collectionId) {
    final query = _db.select(_db.items)
      ..where((t) => t.collectionId.equals(collectionId))
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);
    return query.watch().map(
          (rows) => rows.map(_rowToItem).toList(),
        );
  }

  /// Get a single item by id.
  Future<models.Item?> getItemById(String id) async {
    final query = _db.select(_db.items)
      ..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _rowToItem(row) : null;
  }

  /// Get an item with all its field values.
  Future<models.ItemWithFields?> getItemWithFields(String itemId) async {
    final itemRow = await (_db.select(_db.items)
          ..where((t) => t.id.equals(itemId)))
        .getSingleOrNull();
    if (itemRow == null) return null;

    final valueRows = await (_db.select(_db.itemFieldValues)
          ..where((t) => t.itemId.equals(itemId)))
        .get();

    return _buildItemWithFields(itemRow, valueRows);
  }

  /// Watch an item with all its field values.
  Stream<models.ItemWithFields?> watchItemWithFields(String itemId) {
    final itemQuery = _db.select(_db.items)
      ..where((t) => t.id.equals(itemId));
    final valuesQuery = _db.select(_db.itemFieldValues)
      ..where((t) => t.itemId.equals(itemId));

    return itemQuery.watchSingleOrNull().asyncMap((itemRow) async {
      if (itemRow == null) return null;
      final valueRows = await valuesQuery.get();
      return _buildItemWithFields(itemRow, valueRows);
    });
  }

  /// Insert a new item with its field values (transactional).
  Future<models.ItemWithFields> insertItemWithFields({
    required models.Item item,
    required List<models.FieldValue> fieldValues,
  }) async {
    await _db.transaction(() async {
      await _db.into(_db.items).insert(_itemToCompanion(item));
      for (final fv in fieldValues) {
        await _db
            .into(_db.itemFieldValues)
            .insert(_fieldValueToCompanion(fv));
      }
    });

    final valuesMap = <String, models.FieldValue>{};
    for (final fv in fieldValues) {
      valuesMap[fv.fieldDefinitionId] = fv;
    }
    return models.ItemWithFields(item: item, fieldValues: valuesMap);
  }

  /// Update an item and its field values (transactional).
  Future<void> updateItemWithFields({
    required models.Item item,
    required List<models.FieldValue> fieldValues,
  }) async {
    await _db.transaction(() async {
      await (_db.update(_db.items)..where((t) => t.id.equals(item.id)))
          .write(_itemToCompanion(item));
      for (final fv in fieldValues) {
        await _db.into(_db.itemFieldValues).insertOnConflictUpdate(
              _fieldValueToCompanion(fv),
            );
      }
    });
  }

  /// Delete an item and all its field values.
  Future<void> deleteItem(String id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.itemFieldValues)
            ..where((t) => t.itemId.equals(id)))
          .go();
      await (_db.delete(_db.items)..where((t) => t.id.equals(id))).go();
    });
  }

  /// Toggle favorite status on an item.
  Future<void> toggleFavorite(String itemId) async {
    final item = await (_db.select(_db.items)
          ..where((t) => t.id.equals(itemId)))
        .getSingle();
    await (_db.update(_db.items)..where((t) => t.id.equals(itemId)))
        .write(ItemsCompanion(
      favorite: Value(!item.favorite),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // ── Field Values ───────────────────────────────────────────

  /// Get all field values for an item.
  Future<List<models.FieldValue>> getFieldValues(String itemId) async {
    final rows = await (_db.select(_db.itemFieldValues)
          ..where((t) => t.itemId.equals(itemId)))
        .get();
    return rows.map(_rowToFieldValue).toList();
  }

  // ── Count ──────────────────────────────────────────────────

  /// Count items in a collection.
  Future<int> countItemsInCollection(String collectionId) async {
    final count = _db.items.id.count();
    final query = _db.selectOnly(_db.items)
      ..addColumns([count])
      ..where(_db.items.collectionId.equals(collectionId));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  /// Watch item count for a collection.
  Stream<int> watchItemCount(String collectionId) {
    final count = _db.items.id.count();
    final query = _db.selectOnly(_db.items)
      ..addColumns([count])
      ..where(_db.items.collectionId.equals(collectionId));
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }

  // ── Search ────────────────────────────────────────────────

  /// Search items across all collections by matching field values.
  /// Only searches text-based fields marked as searchable.
  Future<List<models.ItemWithFields>> searchItems(String query) async {
    final pattern = '%$query%';
    const searchableTypes = [
      'text', 'textArea', 'select', 'email', 'url', 'phone', 'barcode',
    ];

    // Find distinct item IDs that have a matching searchable field value.
    final matchingItemIds = await _db.customSelect(
      '''
      SELECT DISTINCT i.id
      FROM items i
      INNER JOIN item_field_values fv ON fv.item_id = i.id
      INNER JOIN field_definitions fd ON fd.id = fv.field_definition_id
      WHERE fd.searchable = 1
        AND fd.type IN (${searchableTypes.map((_) => '?').join(', ')})
        AND fv.value LIKE ?
      ORDER BY i.updated_at DESC
      LIMIT 50
      ''',
      variables: [
        ...searchableTypes.map((t) => Variable.withString(t)),
        Variable.withString(pattern),
      ],
    ).get();

    final ids = matchingItemIds.map((row) => row.read<String>('id')).toList();
    if (ids.isEmpty) return [];

    // Load full ItemWithFields for each matching item.
    final results = <models.ItemWithFields>[];
    for (final id in ids) {
      final item = await getItemWithFields(id);
      if (item != null) results.add(item);
    }
    return results;
  }

  // ── Mapping helpers ────────────────────────────────────────

  models.Item _rowToItem(Item row) {
    return models.Item(
      id: row.id,
      collectionId: row.collectionId,
      favorite: row.favorite,
      syncStatus: models.SyncStatus.values.byName(row.syncStatus),
      serverId: row.serverId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  ItemsCompanion _itemToCompanion(models.Item item) {
    return ItemsCompanion(
      id: Value(item.id),
      collectionId: Value(item.collectionId),
      favorite: Value(item.favorite),
      syncStatus: Value(item.syncStatus.name),
      serverId: Value(item.serverId),
      createdAt: Value(item.createdAt),
      updatedAt: Value(item.updatedAt),
    );
  }

  models.FieldValue _rowToFieldValue(ItemFieldValue row) {
    return models.FieldValue(
      id: row.id,
      itemId: row.itemId,
      fieldDefinitionId: row.fieldDefinitionId,
      value: row.value != null ? jsonDecode(row.value!) : null,
      updatedAt: row.updatedAt,
    );
  }

  ItemFieldValuesCompanion _fieldValueToCompanion(models.FieldValue fv) {
    return ItemFieldValuesCompanion(
      id: Value(fv.id),
      itemId: Value(fv.itemId),
      fieldDefinitionId: Value(fv.fieldDefinitionId),
      value: Value(fv.value != null ? jsonEncode(fv.value) : null),
      updatedAt: Value(fv.updatedAt),
    );
  }

  models.ItemWithFields _buildItemWithFields(
    Item itemRow,
    List<ItemFieldValue> valueRows,
  ) {
    final valuesMap = <String, models.FieldValue>{};
    for (final row in valueRows) {
      valuesMap[row.fieldDefinitionId] = _rowToFieldValue(row);
    }
    return models.ItemWithFields(
      item: _rowToItem(itemRow),
      fieldValues: valuesMap,
    );
  }

  // ── Sync helpers ─────────────────────────────────────────

  /// Get all items that need syncing (not synced).
  Future<List<models.Item>> getPendingItems() async {
    final query = _db.select(_db.items)
      ..where((t) => t.syncStatus.isNotIn(['synced']));
    final rows = await query.get();
    return rows.map(_rowToItem).toList();
  }

  /// Get all field values for pending/modified items.
  Future<List<models.FieldValue>> getPendingFieldValues() async {
    final rows = await _db.customSelect(
      '''
      SELECT fv.* FROM item_field_values fv
      INNER JOIN items i ON i.id = fv.item_id
      WHERE i.sync_status != 'synced'
      ''',
    ).get();
    return rows.map((row) => models.FieldValue(
          id: row.read<String>('id'),
          itemId: row.read<String>('item_id'),
          fieldDefinitionId: row.read<String>('field_definition_id'),
          value: row.readNullable<String>('value') != null
              ? jsonDecode(row.read<String>('value'))
              : null,
          updatedAt: row.read<DateTime>('updated_at'),
        )).toList();
  }

  /// Upsert an item received from the server.
  Future<void> upsertItemFromServer(models.Item item) async {
    await _db.into(_db.items).insertOnConflictUpdate(_itemToCompanion(item));
  }

  /// Upsert a field value received from the server.
  Future<void> upsertFieldValueFromServer(models.FieldValue fieldValue) async {
    await _db
        .into(_db.itemFieldValues)
        .insertOnConflictUpdate(_fieldValueToCompanion(fieldValue));
  }

  /// Mark an item as synced.
  Future<void> markItemSynced(String id) async {
    await (_db.update(_db.items)..where((t) => t.id.equals(id))).write(
      const ItemsCompanion(syncStatus: Value('synced')),
    );
  }

  /// Permanently delete an item (after server confirmed deletion).
  Future<void> deleteItemPermanently(String id) async {
    await deleteItem(id);
  }
}
