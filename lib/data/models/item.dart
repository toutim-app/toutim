import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums/enums.dart';

part 'item.freezed.dart';
part 'item.g.dart';

@freezed
abstract class Item with _$Item {
  const factory Item({
    required String id,
    required String collectionId,
    @Default(false) bool favorite,
    @Default(SyncStatus.pending) SyncStatus syncStatus,
    String? serverId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}
