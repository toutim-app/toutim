import 'package:freezed_annotation/freezed_annotation.dart';

part 'field_value.freezed.dart';
part 'field_value.g.dart';

@freezed
class FieldValue with _$FieldValue {
  const factory FieldValue({
    required String id,
    required String itemId,
    required String fieldDefinitionId,
    dynamic value,
    required DateTime updatedAt,
  }) = _FieldValue;

  factory FieldValue.fromJson(Map<String, dynamic> json) =>
      _$FieldValueFromJson(json);
}
