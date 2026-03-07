import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums/enums.dart';

part 'field_definition.freezed.dart';
part 'field_definition.g.dart';

@freezed
class FieldDefinition with _$FieldDefinition {
  const factory FieldDefinition({
    required String id,
    required String collectionId,
    required String name,
    required FieldType type,
    required int sortOrder,
    @Default(false) bool isRequired,
    @Default(true) bool showInList,
    @Default(true) bool showInCard,
    @Default(true) bool searchable,
    @Default(false) bool sortable,
    dynamic defaultValue,
    @Default({}) Map<String, dynamic> options,
    @Default(SyncStatus.pending) SyncStatus syncStatus,
    String? serverId,
  }) = _FieldDefinition;

  factory FieldDefinition.fromJson(Map<String, dynamic> json) =>
      _$FieldDefinitionFromJson(json);
}
