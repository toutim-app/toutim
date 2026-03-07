import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums/enums.dart';

part 'collection.freezed.dart';
part 'collection.g.dart';

@freezed
class Collection with _$Collection {
  const factory Collection({
    required String id,
    required String name,
    String? description,
    String? icon,
    required String color,
    String? templateId,
    @Default(ViewMode.list) ViewMode viewMode,
    @Default(SyncStatus.pending) SyncStatus syncStatus,
    String? serverId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Collection;

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);
}
