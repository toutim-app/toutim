import '../models/enums/enums.dart';
import '../models/collection.dart';
import '../models/field_definition.dart';

/// Abstract repository for collection operations.
abstract class CollectionRepository {
  /// Watch all collections.
  Stream<List<Collection>> watchAllCollections();

  /// Get a single collection by id.
  Future<Collection?> getCollectionById(String id);

  /// Create a new collection.
  Future<Collection> createCollection({
    required String name,
    String? description,
    String? icon,
    required String color,
    String? templateId,
  });

  /// Update an existing collection.
  Future<void> updateCollection(Collection collection);

  /// Delete a collection and all related data.
  Future<void> deleteCollection(String id);

  /// Get field definitions for a collection.
  Future<List<FieldDefinition>> getFieldDefinitions(String collectionId);

  /// Watch field definitions for a collection.
  Stream<List<FieldDefinition>> watchFieldDefinitions(String collectionId);

  /// Add a field definition to a collection.
  Future<FieldDefinition> addFieldDefinition({
    required String collectionId,
    required String name,
    required FieldType type,
    required int sortOrder,
    bool isRequired = false,
    bool showInList = true,
    bool showInCard = true,
    bool searchable = true,
    bool sortable = false,
    dynamic defaultValue,
    Map<String, dynamic> options = const {},
  });

  /// Update a field definition.
  Future<void> updateFieldDefinition(FieldDefinition definition);

  /// Delete a field definition.
  Future<void> deleteFieldDefinition(String id);

  /// Reorder field definitions.
  Future<void> reorderFieldDefinitions(List<FieldDefinition> definitions);
}
