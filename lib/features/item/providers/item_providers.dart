import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/item_with_fields.dart';
import '../../../data/providers/repository_providers.dart';

part 'item_providers.g.dart';

/// Watches a single item with all its field values.
@riverpod
Stream<ItemWithFields?> itemWithFieldsStream(
  ItemWithFieldsStreamRef ref,
  String itemId,
) {
  return ref.watch(itemRepositoryProvider).watchItemWithFields(itemId);
}
