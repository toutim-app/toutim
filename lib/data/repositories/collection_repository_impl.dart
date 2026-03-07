import 'package:uuid/uuid.dart';

import '../datasources/local/collection_local_datasource.dart';
import '../models/enums/enums.dart';
import '../models/collection.dart';
import '../models/field_definition.dart';
import 'collection_repository.dart';

/// Implementation of [CollectionRepository] backed by local SQLite storage.
class CollectionRepositoryImpl implements CollectionRepository {
  final CollectionLocalDataSource _localDataSource;
  static const _uuid = Uuid();

  CollectionRepositoryImpl(this._localDataSource);

  @override
  Stream<List<Collection>> watchAllCollections() {
    return _localDataSource.watchAllCollections();
  }

  @override
  Future<Collection?> getCollectionById(String id) {
    return _localDataSource.getCollectionById(id);
  }

  @override
  Future<Collection> createCollection({
    required String name,
    String? description,
    String? icon,
    required String color,
    String? templateId,
  }) {
    final now = DateTime.now();
    final collection = Collection(
      id: _uuid.v4(),
      name: name,
      description: description,
      icon: icon,
      color: color,
      templateId: templateId,
      createdAt: now,
      updatedAt: now,
    );
    return _localDataSource.insertCollection(collection);
  }

  @override
  Future<void> updateCollection(Collection collection) {
    return _localDataSource
        .updateCollection(collection.copyWith(updatedAt: DateTime.now()));
  }

  @override
  Future<List<Collection>> searchCollections(String query) {
    return _localDataSource.searchCollections(query);
  }

  @override
  Future<void> deleteCollection(String id) {
    return _localDataSource.deleteCollection(id);
  }

  @override
  Future<List<FieldDefinition>> getFieldDefinitions(String collectionId) {
    return _localDataSource.getFieldDefinitions(collectionId);
  }

  @override
  Stream<List<FieldDefinition>> watchFieldDefinitions(String collectionId) {
    return _localDataSource.watchFieldDefinitions(collectionId);
  }

  @override
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
  }) {
    final definition = FieldDefinition(
      id: _uuid.v4(),
      collectionId: collectionId,
      name: name,
      type: type,
      sortOrder: sortOrder,
      isRequired: isRequired,
      showInList: showInList,
      showInCard: showInCard,
      searchable: searchable,
      sortable: sortable,
      defaultValue: defaultValue,
      options: options,
    );
    return _localDataSource.insertFieldDefinition(definition);
  }

  @override
  Future<void> updateFieldDefinition(FieldDefinition definition) {
    return _localDataSource.updateFieldDefinition(definition);
  }

  @override
  Future<void> deleteFieldDefinition(String id) {
    return _localDataSource.deleteFieldDefinition(id);
  }

  @override
  Future<void> reorderFieldDefinitions(List<FieldDefinition> definitions) {
    return _localDataSource.reorderFieldDefinitions(definitions);
  }
}
