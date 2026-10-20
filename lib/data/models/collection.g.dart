// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Collection _$CollectionFromJson(Map<String, dynamic> json) => _Collection(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  icon: json['icon'] as String?,
  color: json['color'] as String,
  templateId: json['templateId'] as String?,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
  viewMode:
      $enumDecodeNullable(_$ViewModeEnumMap, json['viewMode']) ?? ViewMode.list,
  syncStatus:
      $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
      SyncStatus.pending,
  serverId: json['serverId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CollectionToJson(_Collection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'color': instance.color,
      'templateId': instance.templateId,
      'sortOrder': instance.sortOrder,
      'viewMode': _$ViewModeEnumMap[instance.viewMode]!,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
      'serverId': instance.serverId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ViewModeEnumMap = {
  ViewMode.list: 'list',
  ViewMode.grid: 'grid',
  ViewMode.card: 'card',
};

const _$SyncStatusEnumMap = {
  SyncStatus.pending: 'pending',
  SyncStatus.synced: 'synced',
  SyncStatus.modified: 'modified',
  SyncStatus.deleted: 'deleted',
};
