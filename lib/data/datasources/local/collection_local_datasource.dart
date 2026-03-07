import 'dart:convert';

import 'package:drift/drift.dart';

import '../../models/enums/enums.dart';
import '../../models/collection.dart' as model;
import '../../models/field_definition.dart' as model;
import 'app_database.dart';

/// Datasource for collection and field definition CRUD operations.
class CollectionLocalDataSource {
  final AppDatabase _db;

  CollectionLocalDataSource(this._db);

  // ── Collections ────────────────────────────────────────────

  /// Watch all collections, ordered by updatedAt desc.
  Stream<List<model.Collection>> watchAllCollections() {
    final query = _db.select(_db.collections)
      ..orderBy([
        (t) => OrderingTerm.desc(t.updatedAt),
      ]);
    return query.watch().map(
          (rows) => rows.map(_rowToCollection).toList(),
        );
  }

  /// Get a single collection by id.
  Future<model.Collection?> getCollectionById(String id) async {
    final query = _db.select(_db.collections)
      ..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _rowToCollection(row) : null;
  }

  /// Insert a new collection.
  Future<model.Collection> insertCollection(
      model.Collection collection) async {
    await _db.into(_db.collections).insert(
          _collectionToCompanion(collection),
        );
    return collection;
  }

  /// Update an existing collection.
  Future<void> updateCollection(model.Collection collection) async {
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

  // ── Field Definitions ──────────────────────────────────────

  /// Get all field definitions for a collection, ordered by sortOrder.
  Future<List<model.FieldDefinition>> getFieldDefinitions(
      String collectionId) async {
    final query = _db.select(_db.fieldDefinitions)
      ..where((t) => t.collectionId.equals(collectionId))
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    final rows = await query.get();
    return rows.map(_rowToFieldDefinition).toList();
  }

  /// Watch field definitions for a collection, ordered by sortOrder.
  Stream<List<model.FieldDefinition>> watchFieldDefinitions(
      String collectionId) {
    final query = _db.select(_db.fieldDefinitions)
      ..where((t) => t.collectionId.equals(collectionId))
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    return query.watch().map(
          (rows) => rows.map(_rowToFieldDefinition).toList(),
        );
  }

  /// Insert a field definition.
  Future<model.FieldDefinition> insertFieldDefinition(
      model.FieldDefinition definition) async {
    await _db.into(_db.fieldDefinitions).insert(
          _fieldDefinitionToCompanion(definition),
        );
    return definition;
  }

  /// Update a field definition.
  Future<void> updateFieldDefinition(
      model.FieldDefinition definition) async {
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
      List<model.FieldDefinition> definitions) async {
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

  model.Collection _rowToCollection(CollectionData row) {
    return model.Collection(
      id: row.id,
      name: row.name,
      description: row.description,
      icon: row.icon,
      color: row.color,
      templateId: row.templateId,
      viewMode: ViewMode.values.byName(row.viewMode),
      syncStatus: SyncStatus.values.byName(row.syncStatus),
      serverId: row.serverId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  CollectionsCompanion _collectionToCompanion(model.Collection c) {
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

  model.FieldDefinition _rowToFieldDefinition(FieldDefinitionData row) {
    return model.FieldDefinition(
      id: row.id,
      collectionId: row.collectionId,
      name: row.name,
      type: FieldType.values.byName(row.type),
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
      syncStatus: SyncStatus.values.byName(row.syncStatus),
      serverId: row.serverId,
    );
  }

  FieldDefinitionsCompanion _fieldDefinitionToCompanion(
      model.FieldDefinition d) {
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
