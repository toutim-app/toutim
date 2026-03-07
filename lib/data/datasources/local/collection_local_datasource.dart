import 'dart:convert';

import 'package:drift/drift.dart';

import '../../models/models.dart' as models;
import 'app_database.dart';

/// Datasource for collection and field definition CRUD operations.
class CollectionLocalDataSource {
  final AppDatabase _db;

  CollectionLocalDataSource(this._db);

  // ── Collections ────────────────────────────────────────────

  /// Watch all collections, ordered by updatedAt desc.
  Stream<List<models.Collection>> watchAllCollections() {
    final query = _db.select(_db.collections)
      ..orderBy([
        (t) => OrderingTerm.desc(t.updatedAt),
      ]);
    return query.watch().map(
          (rows) => rows.map(_rowToCollection).toList(),
        );
  }

  /// Get a single collection by id.
  Future<models.Collection?> getCollectionById(String id) async {
    final query = _db.select(_db.collections)
      ..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _rowToCollection(row) : null;
  }

  /// Insert a new collection.
  Future<models.Collection> insertCollection(
      models.Collection collection) async {
    await _db.into(_db.collections).insert(
          _collectionToCompanion(collection),
        );
    return collection;
  }

  /// Update an existing collection.
  Future<void> updateCollection(models.Collection collection) async {
    await (_db.update(_db.collections)
          ..where((t) => t.id.equals(collection.id)))
        .write(_collectionToCompanion(collection));
  }

  /// Delete a collection and all its field definitions, items, and field values.
  Future<void> deleteCollection(String id) async {
    await _db.transaction(() async {
      // Get all items for this collection
      final items = await (_db.select(_db.items)
            ..where((t) => t.collectionId.equals(id)))
          .get();
      final itemIds = items.map((i) => i.id).toList();

      // Delete field values for all items
      if (itemIds.isNotEmpty) {
        await (_db.delete(_db.itemFieldValues)
              ..where((t) => t.itemId.isIn(itemIds)))
            .go();
      }

      // Delete items
      await (_db.delete(_db.items)
            ..where((t) => t.collectionId.equals(id)))
          .go();

      // Delete field definitions
      await (_db.delete(_db.fieldDefinitions)
            ..where((t) => t.collectionId.equals(id)))
          .go();

      // Delete the collection
      await (_db.delete(_db.collections)..where((t) => t.id.equals(id)))
          .go();
    });
  }

  // ── Search ────────────────────────────────────────────────

  /// Search collections by name.
  Future<List<models.Collection>> searchCollections(String query) async {
    final q = _db.select(_db.collections)
      ..where((t) => t.name.like('%$query%'))
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);
    final rows = await q.get();
    return rows.map(_rowToCollection).toList();
  }

  // ── Field Definitions ──────────────────────────────────────

  /// Get all field definitions for a collection, ordered by sortOrder.
  Future<List<models.FieldDefinition>> getFieldDefinitions(
      String collectionId) async {
    final query = _db.select(_db.fieldDefinitions)
      ..where((t) => t.collectionId.equals(collectionId))
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    final rows = await query.get();
    return rows.map(_rowToFieldDefinition).toList();
  }

  /// Watch field definitions for a collection, ordered by sortOrder.
  Stream<List<models.FieldDefinition>> watchFieldDefinitions(
      String collectionId) {
    final query = _db.select(_db.fieldDefinitions)
      ..where((t) => t.collectionId.equals(collectionId))
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    return query.watch().map(
          (rows) => rows.map(_rowToFieldDefinition).toList(),
        );
  }

  /// Insert a field definition.
  Future<models.FieldDefinition> insertFieldDefinition(
      models.FieldDefinition definition) async {
    await _db.into(_db.fieldDefinitions).insert(
          _fieldDefinitionToCompanion(definition),
        );
    return definition;
  }

  /// Update a field definition.
  Future<void> updateFieldDefinition(
      models.FieldDefinition definition) async {
    await (_db.update(_db.fieldDefinitions)
          ..where((t) => t.id.equals(definition.id)))
        .write(_fieldDefinitionToCompanion(definition));
  }

  /// Delete a field definition and its associated field values.
  Future<void> deleteFieldDefinition(String id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.itemFieldValues)
            ..where((t) => t.fieldDefinitionId.equals(id)))
          .go();
      await (_db.delete(_db.fieldDefinitions)
            ..where((t) => t.id.equals(id)))
          .go();
    });
  }

  /// Reorder field definitions (batch update sortOrder).
  Future<void> reorderFieldDefinitions(
      List<models.FieldDefinition> definitions) async {
    await _db.transaction(() async {
      for (final def in definitions) {
        await (_db.update(_db.fieldDefinitions)
              ..where((t) => t.id.equals(def.id)))
            .write(
          FieldDefinitionsCompanion(sortOrder: Value(def.sortOrder)),
        );
      }
    });
  }

  // ── Mapping helpers ────────────────────────────────────────

  models.Collection _rowToCollection(Collection row) {
    return models.Collection(
      id: row.id,
      name: row.name,
      description: row.description,
      icon: row.icon,
      color: row.color,
      templateId: row.templateId,
      viewMode: models.ViewMode.values.byName(row.viewMode),
      syncStatus: models.SyncStatus.values.byName(row.syncStatus),
      serverId: row.serverId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  CollectionsCompanion _collectionToCompanion(models.Collection c) {
    return CollectionsCompanion(
      id: Value(c.id),
      name: Value(c.name),
      description: Value(c.description),
      icon: Value(c.icon),
      color: Value(c.color),
      templateId: Value(c.templateId),
      viewMode: Value(c.viewMode.name),
      syncStatus: Value(c.syncStatus.name),
      serverId: Value(c.serverId),
      createdAt: Value(c.createdAt),
      updatedAt: Value(c.updatedAt),
    );
  }

  models.FieldDefinition _rowToFieldDefinition(FieldDefinition row) {
    return models.FieldDefinition(
      id: row.id,
      collectionId: row.collectionId,
      name: row.name,
      type: models.FieldType.values.byName(row.type),
      sortOrder: row.sortOrder,
      isRequired: row.isRequired,
      showInList: row.showInList,
      showInCard: row.showInCard,
      searchable: row.searchable,
      sortable: row.sortable,
      defaultValue:
          row.defaultValue != null ? jsonDecode(row.defaultValue!) : null,
      options:
          (jsonDecode(row.options) as Map<String, dynamic>?) ?? {},
      syncStatus: models.SyncStatus.values.byName(row.syncStatus),
      serverId: row.serverId,
    );
  }

  FieldDefinitionsCompanion _fieldDefinitionToCompanion(
      models.FieldDefinition d) {
    return FieldDefinitionsCompanion(
      id: Value(d.id),
      collectionId: Value(d.collectionId),
      name: Value(d.name),
      type: Value(d.type.name),
      sortOrder: Value(d.sortOrder),
      isRequired: Value(d.isRequired),
      showInList: Value(d.showInList),
      showInCard: Value(d.showInCard),
      searchable: Value(d.searchable),
      sortable: Value(d.sortable),
      defaultValue: Value(
          d.defaultValue != null ? jsonEncode(d.defaultValue) : null),
      options: Value(jsonEncode(d.options)),
      syncStatus: Value(d.syncStatus.name),
      serverId: Value(d.serverId),
    );
  }
}
