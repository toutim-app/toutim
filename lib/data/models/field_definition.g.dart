// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FieldDefinition _$FieldDefinitionFromJson(Map<String, dynamic> json) =>
    _FieldDefinition(
      id: json['id'] as String,
      collectionId: json['collectionId'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$FieldTypeEnumMap, json['type']),
      sortOrder: (json['sortOrder'] as num).toInt(),
      isRequired: json['isRequired'] as bool? ?? false,
      showInList: json['showInList'] as bool? ?? true,
      showInCard: json['showInCard'] as bool? ?? true,
      searchable: json['searchable'] as bool? ?? true,
      sortable: json['sortable'] as bool? ?? false,
      defaultValue: json['defaultValue'],
      options: json['options'] as Map<String, dynamic>? ?? const {},
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
          SyncStatus.pending,
      serverId: json['serverId'] as String?,
    );

Map<String, dynamic> _$FieldDefinitionToJson(_FieldDefinition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'collectionId': instance.collectionId,
      'name': instance.name,
      'type': _$FieldTypeEnumMap[instance.type]!,
      'sortOrder': instance.sortOrder,
      'isRequired': instance.isRequired,
      'showInList': instance.showInList,
      'showInCard': instance.showInCard,
      'searchable': instance.searchable,
      'sortable': instance.sortable,
      'defaultValue': instance.defaultValue,
      'options': instance.options,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
      'serverId': instance.serverId,
    };

const _$FieldTypeEnumMap = {
  FieldType.text: 'text',
  FieldType.textArea: 'textArea',
  FieldType.number: 'number',
  FieldType.decimal: 'decimal',
  FieldType.currency: 'currency',
  FieldType.boolean: 'boolean',
  FieldType.date: 'date',
  FieldType.dateTime: 'dateTime',
  FieldType.time: 'time',
  FieldType.image: 'image',
  FieldType.barcode: 'barcode',
  FieldType.qrCode: 'qrCode',
  FieldType.rating: 'rating',
  FieldType.url: 'url',
  FieldType.email: 'email',
  FieldType.phone: 'phone',
  FieldType.select: 'select',
  FieldType.multiSelect: 'multiSelect',
  FieldType.tags: 'tags',
  FieldType.color: 'color',
  FieldType.location: 'location',
  FieldType.slider: 'slider',
  FieldType.range: 'range',
  FieldType.duration: 'duration',
  FieldType.checklist: 'checklist',
  FieldType.tracker: 'tracker',
};

const _$SyncStatusEnumMap = {
  SyncStatus.pending: 'pending',
  SyncStatus.synced: 'synced',
  SyncStatus.modified: 'modified',
  SyncStatus.deleted: 'deleted',
};
