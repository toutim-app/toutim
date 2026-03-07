import '../models/item.dart';
import '../models/item_with_fields.dart';

/// Abstract repository for item operations.
abstract class ItemRepository {
  /// Watch all items in a collection.
  Stream<List<Item>> watchItemsByCollection(String collectionId);

  /// Get an item with all its field values.
  Future<ItemWithFields?> getItemWithFields(String itemId);

  /// Watch an item with all its field values.
  Stream<ItemWithFields?> watchItemWithFields(String itemId);

  /// Create a new item with field values.
  Future<ItemWithFields> createItem({
    required String collectionId,
    required Map<String, dynamic> fieldValues,
  });

  /// Update an item's field values.
  Future<void> updateItem({
    required String itemId,
    required Map<String, dynamic> fieldValues,
  });

  /// Delete an item.
  Future<void> deleteItem(String id);

  /// Toggle favorite status.
  Future<void> toggleFavorite(String itemId);

  /// Get item count for a collection.
  Future<int> countItemsInCollection(String collectionId);

  /// Watch item count for a collection.
  Stream<int> watchItemCount(String collectionId);
}
