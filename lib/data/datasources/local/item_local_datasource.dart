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
}
