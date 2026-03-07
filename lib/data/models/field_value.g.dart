// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FieldValueImpl _$$FieldValueImplFromJson(Map<String, dynamic> json) =>
    _$FieldValueImpl(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      fieldDefinitionId: json['fieldDefinitionId'] as String,
      value: json['value'],
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$FieldValueImplToJson(_$FieldValueImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'fieldDefinitionId': instance.fieldDefinitionId,
      'value': instance.value,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
