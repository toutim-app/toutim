/// A single entity change for sync push/pull.
class SyncChange {
  final String entity;
  final String id;
  final String action;
  final String clientUpdatedAt;
  final Map<String, dynamic>? data;

  const SyncChange({
    required this.entity,
    required this.id,
    required this.action,
    required this.clientUpdatedAt,
    this.data,
  });

  factory SyncChange.fromJson(Map<String, dynamic> json) => SyncChange(
        entity: json['entity'] as String,
        id: json['id'] as String,
        action: json['action'] as String,
        clientUpdatedAt: json['client_updated_at'] as String,
        data: json['data'] as Map<String, dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'entity': entity,
        'id': id,
        'action': action,
        'client_updated_at': clientUpdatedAt,
        if (data != null) 'data': data,
      };
}

/// Response from POST /api/sync/push.
class PushResponse {
  final int applied;
  final int version;
  final List<SyncConflict> conflicts;

  const PushResponse({
    required this.applied,
    required this.version,
    this.conflicts = const [],
  });

  factory PushResponse.fromJson(Map<String, dynamic> json) => PushResponse(
        applied: json['applied'] as int,
        version: json['version'] as int,
        conflicts: (json['conflicts'] as List<dynamic>?)
                ?.map(
                    (e) => SyncConflict.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

/// Response from POST /api/sync/pull.
class PullResponse {
  final List<SyncChange> changes;
  final int version;

  const PullResponse({required this.changes, required this.version});

  factory PullResponse.fromJson(Map<String, dynamic> json) => PullResponse(
        changes: (json['changes'] as List<dynamic>?)
                ?.map((e) => SyncChange.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        version: json['version'] as int,
      );
}

/// Response from GET /api/sync/status.
class SyncStatusResponse {
  final String? lastSyncAt;
  final int currentVersion;
  final int storageBytes;

  const SyncStatusResponse({
    this.lastSyncAt,
    required this.currentVersion,
    required this.storageBytes,
  });

  factory SyncStatusResponse.fromJson(Map<String, dynamic> json) =>
      SyncStatusResponse(
        lastSyncAt: json['last_sync_at'] as String?,
        currentVersion: json['current_version'] as int,
        storageBytes: json['storage_bytes'] as int,
      );
}

/// A conflict returned by the server during push.
class SyncConflict {
  final String entity;
  final String id;
  final String resolution;
  final Map<String, dynamic>? clientData;
  final Map<String, dynamic>? serverData;

  const SyncConflict({
    required this.entity,
    required this.id,
    required this.resolution,
    this.clientData,
    this.serverData,
  });

  factory SyncConflict.fromJson(Map<String, dynamic> json) => SyncConflict(
        entity: json['entity'] as String,
        id: json['id'] as String,
        resolution: json['resolution'] as String,
        clientData: json['client_data'] as Map<String, dynamic>?,
        serverData: json['server_data'] as Map<String, dynamic>?,
      );
}

/// Breakdown of synced entities by type.
class SyncEntityCounts {
  final int collections;
  final int items;

  const SyncEntityCounts({this.collections = 0, this.items = 0});

  bool get isEmpty => collections == 0 && items == 0;
}

/// Result of a sync operation (push + pull).
class SyncResult {
  final SyncEntityCounts pushed;
  final SyncEntityCounts pulled;
  final int conflicts;
  final int newVersion;

  const SyncResult({
    this.pushed = const SyncEntityCounts(),
    this.pulled = const SyncEntityCounts(),
    required this.conflicts,
    required this.newVersion,
  });
}
