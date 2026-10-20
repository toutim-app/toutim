// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FieldValue _$FieldValueFromJson(Map<String, dynamic> json) => _FieldValue(
  id: json['id'] as String,
  itemId: json['itemId'] as String,
  fieldDefinitionId: json['fieldDefinitionId'] as String,
  value: json['value'],
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$FieldValueToJson(_FieldValue instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'fieldDefinitionId': instance.fieldDefinitionId,
      'value': instance.value,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
