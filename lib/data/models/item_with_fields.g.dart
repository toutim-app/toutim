// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_with_fields.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemWithFieldsImpl _$$ItemWithFieldsImplFromJson(Map<String, dynamic> json) =>
    _$ItemWithFieldsImpl(
      item: Item.fromJson(json['item'] as Map<String, dynamic>),
      fieldValues:
          (json['fieldValues'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, FieldValue.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$ItemWithFieldsImplToJson(
  _$ItemWithFieldsImpl instance,
) => <String, dynamic>{
  'item': instance.item,
  'fieldValues': instance.fieldValues,
};
