import 'package:freezed_annotation/freezed_annotation.dart';

import 'field_value.dart';
import 'item.dart';

part 'item_with_fields.freezed.dart';
part 'item_with_fields.g.dart';

/// Aggregate model: an Item with all its field values, keyed by fieldDefinitionId.
@freezed
abstract class ItemWithFields with _$ItemWithFields {
  const factory ItemWithFields({
    required Item item,
    @Default({}) Map<String, FieldValue> fieldValues,
  }) = _ItemWithFields;

  factory ItemWithFields.fromJson(Map<String, dynamic> json) =>
      _$ItemWithFieldsFromJson(json);
}
