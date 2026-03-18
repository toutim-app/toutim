import 'package:uuid/uuid.dart';

import '../datasources/local/item_local_datasource.dart';
import '../models/enums/sync_status.dart';
import '../models/field_value.dart';
import '../models/item.dart';
import '../models/item_with_fields.dart';
import 'item_repository.dart';

/// Implementation of [ItemRepository] backed by local SQLite storage.
class ItemRepositoryImpl implements ItemRepository {
  final ItemLocalDataSource _localDataSource;
  static const _uuid = Uuid();

  ItemRepositoryImpl(this._localDataSource);

  @override
  Stream<List<Item>> watchItemsByCollection(String collectionId) {
    return _localDataSource.watchItemsByCollection(collectionId);
  }

  @override
  Future<ItemWithFields?> getItemWithFields(String itemId) {
    return _localDataSource.getItemWithFields(itemId);
  }

  @override
  Stream<ItemWithFields?> watchItemWithFields(String itemId) {
    return _localDataSource.watchItemWithFields(itemId);
  }

  @override
  Stream<List<ItemWithFields>> watchAllItemsWithFields(String collectionId) {
    return _localDataSource.watchAllItemsWithFields(collectionId);
  }

  @override
  Future<ItemWithFields> createItem({
    required String collectionId,
    required Map<String, dynamic> fieldValues,
  }) {
    final now = DateTime.now();
    final itemId = _uuid.v4();
    final item = Item(
      id: itemId,
      collectionId: collectionId,
      createdAt: now,
      updatedAt: now,
    );
    final values = fieldValues.entries.map((e) {
      return FieldValue(
        id: _uuid.v4(),
        itemId: itemId,
        fieldDefinitionId: e.key,
        value: e.value,
        updatedAt: now,
      );
    }).toList();
    return _localDataSource.insertItemWithFields(
      item: item,
      fieldValues: values,
    );
  }

  @override
  Future<void> updateItem({
    required String itemId,
    required Map<String, dynamic> fieldValues,
  }) async {
    final existing = await _localDataSource.getItemById(itemId);
    if (existing == null) return;

    final now = DateTime.now();
    final updatedItem = existing.copyWith(
      updatedAt: now,
      syncStatus: SyncStatus.pending,
    );

    final existingValues = await _localDataSource.getFieldValues(itemId);
    final existingMap = {
      for (final v in existingValues) v.fieldDefinitionId: v
    };

    final values = fieldValues.entries.map((e) {
      final existing = existingMap[e.key];
      return FieldValue(
        id: existing?.id ?? _uuid.v4(),
        itemId: itemId,
        fieldDefinitionId: e.key,
        value: e.value,
        updatedAt: now,
      );
    }).toList();

    await _localDataSource.updateItemWithFields(
      item: updatedItem,
      fieldValues: values,
    );
  }

  @override
  Future<List<ItemWithFields>> searchItems(String query) {
    return _localDataSource.searchItems(query);
  }

  @override
  Future<void> deleteItem(String id) {
    return _localDataSource.deleteItem(id);
  }

  @override
  Future<void> toggleFavorite(String itemId) {
    return _localDataSource.toggleFavorite(itemId);
  }

  @override
  Future<int> countItemsInCollection(String collectionId) {
    return _localDataSource.countItemsInCollection(collectionId);
  }

  @override
  Stream<int> watchItemCount(String collectionId) {
    return _localDataSource.watchItemCount(collectionId);
  }
}
