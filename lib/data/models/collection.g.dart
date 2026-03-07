// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CollectionImpl _$$CollectionImplFromJson(Map<String, dynamic> json) =>
    _$CollectionImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String,
      templateId: json['templateId'] as String?,
      viewMode:
          $enumDecodeNullable(_$ViewModeEnumMap, json['viewMode']) ??
          ViewMode.list,
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
          SyncStatus.pending,
      serverId: json['serverId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CollectionImplToJson(_$CollectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'color': instance.color,
      'templateId': instance.templateId,
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
