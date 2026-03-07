import 'dart:convert';

import 'package:drift/drift.dart';

import '../../models/enums/enums.dart';
import '../../models/field_value.dart' as model;
import '../../models/item.dart' as model;
import '../../models/item_with_fields.dart' as model;
import 'app_database.dart';

/// Datasource for item and field value CRUD operations.
class ItemLocalDataSource {
  final AppDatabase _db;

  ItemLocalDataSource(this._db);

  // ── Items ──────────────────────────────────────────────────

  /// Watch all items in a collection, ordered by updatedAt desc.
  Stream<List<model.Item>> watchItemsByCollection(String collectionId) {
    final query = _db.select(_db.items)
      ..where((t) => t.collectionId.equals(collectionId))
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);
    return query.watch().map(
          (rows) => rows.map(_rowToItem).toList(),
        );
  }

  /// Get a single item by id.
  Future<model.Item?> getItemById(String id) async {
    final query = _db.select(_db.items)
      ..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _rowToItem(row) : null;
  }

  /// Get an item with all its field values.
  Future<model.ItemWithFields?> getItemWithFields(String itemId) async {
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
  Stream<model.ItemWithFields?> watchItemWithFields(String itemId) {
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
  Future<model.ItemWithFields> insertItemWithFields({
    required model.Item item,
    required List<model.FieldValue> fieldValues,
  }) async {
    await _db.transaction(() async {
      await _db.into(_db.items).insert(_itemToCompanion(item));
      for (final fv in fieldValues) {
        await _db
            .into(_db.itemFieldValues)
            .insert(_fieldValueToCompanion(fv));
      }
    });

    final valuesMap = <String, model.FieldValue>{};
    for (final fv in fieldValues) {
      valuesMap[fv.fieldDefinitionId] = fv;
    }
    return model.ItemWithFields(item: item, fieldValues: valuesMap);
  }

  /// Update an item and its field values (transactional).
  Future<void> updateItemWithFields({
    required model.Item item,
    required List<model.FieldValue> fieldValues,
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
  Future<List<model.FieldValue>> getFieldValues(String itemId) async {
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

  model.Item _rowToItem(ItemData row) {
    return model.Item(
      id: row.id,
      collectionId: row.collectionId,
      favorite: row.favorite,
      syncStatus: SyncStatus.values.byName(row.syncStatus),
      serverId: row.serverId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  ItemsCompanion _itemToCompanion(model.Item item) {
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

  model.FieldValue _rowToFieldValue(ItemFieldValueData row) {
    return model.FieldValue(
      id: row.id,
      itemId: row.itemId,
      fieldDefinitionId: row.fieldDefinitionId,
      value: row.value != null ? jsonDecode(row.value!) : null,
      updatedAt: row.updatedAt,
    );
  }

  ItemFieldValuesCompanion _fieldValueToCompanion(model.FieldValue fv) {
    return ItemFieldValuesCompanion(
      id: Value(fv.id),
      itemId: Value(fv.itemId),
      fieldDefinitionId: Value(fv.fieldDefinitionId),
      value: Value(fv.value != null ? jsonEncode(fv.value) : null),
      updatedAt: Value(fv.updatedAt),
    );
  }

  model.ItemWithFields _buildItemWithFields(
    ItemData itemRow,
    List<ItemFieldValueData> valueRows,
  ) {
    final valuesMap = <String, model.FieldValue>{};
    for (final row in valueRows) {
      valuesMap[row.fieldDefinitionId] = _rowToFieldValue(row);
    }
    return model.ItemWithFields(
      item: _rowToItem(itemRow),
      fieldValues: valuesMap,
    );
  }
}
