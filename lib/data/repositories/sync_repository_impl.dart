import 'dart:convert';

import '../datasources/local/collection_local_datasource.dart';
import '../datasources/local/item_local_datasource.dart';
import '../datasources/remote/api_client.dart';
import '../models/models.dart';
import '../models/sync_change.dart';
import 'sync_repository.dart';

/// Implementation of [SyncRepository] that coordinates push/pull with the server.
class SyncRepositoryImpl implements SyncRepository {
  final ApiClient _apiClient;
  final CollectionLocalDataSource _collectionDs;
  final ItemLocalDataSource _itemDs;

  SyncRepositoryImpl({
    required ApiClient apiClient,
    required CollectionLocalDataSource collectionDs,
    required ItemLocalDataSource itemDs,
  })  : _apiClient = apiClient,
        _collectionDs = collectionDs,
        _itemDs = itemDs;

  @override
  bool get isConfigured => _apiClient.isConfigured;

  @override
  Future<bool> get isAuthenticated => _apiClient.isAuthenticated;

  @override
  String get serverUrl => _apiClient.serverUrl;

  @override
  Future<String?> get userEmail => _apiClient.userEmail;

  @override
  Future<void> setServerUrl(String url) => _apiClient.setServerUrl(url);

  @override
  Future<bool> testConnection() => _apiClient.testConnection();

  @override
  Future<void> register(String email, String password) =>
      _apiClient.register(email, password);

  @override
  Future<void> login(String email, String password) =>
      _apiClient.login(email, password);

  @override
  Future<void> logout() => _apiClient.logout();

  @override
  Future<void> deleteAccount() => _apiClient.deleteAccount();

  @override
  Future<void> forgotPassword(String email) =>
      _apiClient.forgotPassword(email);

  @override
  Future<SyncResult> sync() async {
    final lastVersion = _apiClient.syncVersion;

    // 1. Collect local changes.
    final changes = await _collectLocalChanges();

    // 2. Push local changes to server.
    var pushedCounts = const SyncEntityCounts();
    int versionAfterPush = lastVersion;
    if (changes.isNotEmpty) {
      final pushResponse =
          await _apiClient.pushChanges(changes, lastVersion);
      versionAfterPush = pushResponse.version;
      pushedCounts = _countEntities(changes);

      // 3. Mark pushed entities as synced.
      await _markEntitiesSynced(changes);
    }

    // 4. Pull remote changes (since the version after push to avoid
    //    re-downloading the changes we just pushed).
    final pullResponse = await _apiClient.pullChanges(versionAfterPush);
    var pulledCounts = const SyncEntityCounts();
    if (pullResponse.changes.isNotEmpty) {
      await _applyRemoteChanges(pullResponse.changes);
      pulledCounts = _countEntities(pullResponse.changes);
    }

    // 5. Save the new version cursor.
    await _apiClient.setSyncVersion(pullResponse.version);

    return SyncResult(
      pushed: pushedCounts,
      pulled: pulledCounts,
      conflicts: 0,
      newVersion: pullResponse.version,
    );
  }

  /// Collect all local entities with syncStatus != synced and build SyncChange list.
  Future<List<SyncChange>> _collectLocalChanges() async {
    final changes = <SyncChange>[];

    // Collections first (FK parent).
    final pendingCollections = await _collectionDs.getPendingCollections();
    for (final c in pendingCollections) {
      changes.add(SyncChange(
        entity: 'collection',
        id: c.id,
        action: c.syncStatus == SyncStatus.deleted ? 'delete' : 'create',
        clientUpdatedAt: c.updatedAt.toUtc().toIso8601String(),
        data: c.syncStatus == SyncStatus.deleted
            ? null
            : {
                'id': c.id,
                'name': c.name,
                'description': c.description,
                'icon': c.icon,
                'color': c.color,
                'template_id': c.templateId,
                'view_mode': c.viewMode.name,
                'sync_status': 'synced',
                'created_at': c.createdAt.toUtc().toIso8601String(),
                'updated_at': c.updatedAt.toUtc().toIso8601String(),
              },
      ));
    }

    // Field definitions (depends on collection).
    final pendingFieldDefs = await _collectionDs.getPendingFieldDefinitions();
    for (final fd in pendingFieldDefs) {
      changes.add(SyncChange(
        entity: 'field_definition',
        id: fd.id,
        action: fd.syncStatus == SyncStatus.deleted ? 'delete' : 'create',
        clientUpdatedAt: DateTime.now().toUtc().toIso8601String(),
        data: fd.syncStatus == SyncStatus.deleted
            ? null
            : {
                'id': fd.id,
                'collection_id': fd.collectionId,
                'name': fd.name,
                'type': fd.type.name,
                'sort_order': fd.sortOrder,
                'is_required': fd.isRequired ? 1 : 0,
                'show_in_list': fd.showInList ? 1 : 0,
                'show_in_card': fd.showInCard ? 1 : 0,
                'searchable': fd.searchable ? 1 : 0,
                'sortable': fd.sortable ? 1 : 0,
                'default_value': fd.defaultValue != null
                    ? jsonEncode(fd.defaultValue)
                    : null,
                'options': jsonEncode(fd.options),
                'sync_status': 'synced',
              },
      ));
    }

    // Items (depends on collection).
    final pendingItems = await _itemDs.getPendingItems();
    for (final item in pendingItems) {
      changes.add(SyncChange(
        entity: 'item',
        id: item.id,
        action: item.syncStatus == SyncStatus.deleted ? 'delete' : 'create',
        clientUpdatedAt: item.updatedAt.toUtc().toIso8601String(),
        data: item.syncStatus == SyncStatus.deleted
            ? null
            : {
                'id': item.id,
                'collection_id': item.collectionId,
                'favorite': item.favorite ? 1 : 0,
                'sync_status': 'synced',
                'created_at': item.createdAt.toUtc().toIso8601String(),
                'updated_at': item.updatedAt.toUtc().toIso8601String(),
              },
      ));
    }

    // Field values (depends on item + field_definition).
    final pendingFieldValues = await _itemDs.getPendingFieldValues();
    for (final fv in pendingFieldValues) {
      changes.add(SyncChange(
        entity: 'field_value',
        id: fv.id,
        action: 'create',
        clientUpdatedAt: fv.updatedAt.toUtc().toIso8601String(),
        data: {
          'id': fv.id,
          'item_id': fv.itemId,
          'field_definition_id': fv.fieldDefinitionId,
          'value': fv.value != null ? jsonEncode(fv.value) : null,
          'updated_at': fv.updatedAt.toUtc().toIso8601String(),
        },
      ));
    }

    return changes;
  }

  /// Mark all entities in the changes list as synced locally.
  Future<void> _markEntitiesSynced(List<SyncChange> changes) async {
    for (final change in changes) {
      if (change.action == 'delete') continue;
      switch (change.entity) {
        case 'collection':
          await _collectionDs.markCollectionSynced(change.id);
        case 'field_definition':
          await _collectionDs.markFieldDefinitionSynced(change.id);
        case 'item':
          await _itemDs.markItemSynced(change.id);
        // field_values don't have syncStatus.
      }
    }
  }

  /// Apply remote changes from pull to local database.
  Future<void> _applyRemoteChanges(List<SyncChange> changes) async {
    for (final change in changes) {
      switch (change.entity) {
        case 'collection':
          await _applyCollectionChange(change);
        case 'field_definition':
          await _applyFieldDefinitionChange(change);
        case 'item':
          await _applyItemChange(change);
        case 'field_value':
          await _applyFieldValueChange(change);
      }
    }
  }

  Future<void> _applyCollectionChange(SyncChange change) async {
    if (change.action == 'delete') {
      await _collectionDs.deleteCollectionPermanently(change.id);
      return;
    }
    final data = change.data!;
    final collection = Collection(
      id: data['id'] as String,
      name: data['name'] as String,
      description: data['description'] as String?,
      icon: data['icon'] as String?,
      color: data['color'] as String? ?? 'blue',
      templateId: data['template_id'] as String?,
      viewMode: _parseViewMode(data['view_mode']),
      syncStatus: SyncStatus.synced,
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: DateTime.parse(data['updated_at'] as String),
    );
    await _collectionDs.upsertCollectionFromServer(collection);
  }

  Future<void> _applyFieldDefinitionChange(SyncChange change) async {
    if (change.action == 'delete') {
      await _collectionDs.deleteFieldDefinition(change.id);
      return;
    }
    final data = change.data!;
    final fieldDef = FieldDefinition(
      id: data['id'] as String,
      collectionId: data['collection_id'] as String,
      name: data['name'] as String,
      type: FieldType.values.byName(data['type'] as String),
      sortOrder: (data['sort_order'] as num).toInt(),
      isRequired: _toBool(data['is_required']),
      showInList: _toBool(data['show_in_list']),
      showInCard: _toBool(data['show_in_card']),
      searchable: _toBool(data['searchable']),
      sortable: _toBool(data['sortable']),
      defaultValue: data['default_value'] != null
          ? jsonDecode(data['default_value'] as String)
          : null,
      options: data['options'] != null
          ? (jsonDecode(data['options'] as String) as Map<String, dynamic>)
          : {},
      syncStatus: SyncStatus.synced,
    );
    await _collectionDs.upsertFieldDefinitionFromServer(fieldDef);
  }

  Future<void> _applyItemChange(SyncChange change) async {
    if (change.action == 'delete') {
      await _itemDs.deleteItemPermanently(change.id);
      return;
    }
    final data = change.data!;
    final item = Item(
      id: data['id'] as String,
      collectionId: data['collection_id'] as String,
      favorite: _toBool(data['favorite']),
      syncStatus: SyncStatus.synced,
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: DateTime.parse(data['updated_at'] as String),
    );
    await _itemDs.upsertItemFromServer(item);
  }

  Future<void> _applyFieldValueChange(SyncChange change) async {
    if (change.action == 'delete') return;
    final data = change.data!;
    final fieldValue = FieldValue(
      id: data['id'] as String,
      itemId: data['item_id'] as String,
      fieldDefinitionId: data['field_definition_id'] as String,
      value: data['value'] != null ? jsonDecode(data['value'] as String) : null,
      updatedAt: DateTime.parse(data['updated_at'] as String),
    );
    await _itemDs.upsertFieldValueFromServer(fieldValue);
  }

  ViewMode _parseViewMode(dynamic value) {
    if (value == null) return ViewMode.list;
    try {
      return ViewMode.values.byName(value as String);
    } catch (_) {
      return ViewMode.list;
    }
  }

  bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) return value == 'true' || value == '1';
    return false;
  }

  /// Count only user-visible entities (collections and items).
  SyncEntityCounts _countEntities(List<SyncChange> changes) {
    int collections = 0;
    int items = 0;
    for (final c in changes) {
      switch (c.entity) {
        case 'collection':
          collections++;
        case 'item':
          items++;
      }
    }
    return SyncEntityCounts(collections: collections, items: items);
  }
}
