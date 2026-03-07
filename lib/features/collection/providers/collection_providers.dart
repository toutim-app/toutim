import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/field_definition.dart';
import '../../../data/models/item.dart';
import '../../../data/providers/repository_providers.dart';

part 'collection_providers.g.dart';

/// Watches field definitions for a specific collection.
@riverpod
Stream<List<FieldDefinition>> fieldDefinitionsStream(
  FieldDefinitionsStreamRef ref,
  String collectionId,
) {
  return ref
      .watch(collectionRepositoryProvider)
      .watchFieldDefinitions(collectionId);
}

/// Watches items for a specific collection.
@riverpod
Stream<List<Item>> itemsStream(
  ItemsStreamRef ref,
  String collectionId,
) {
  return ref
      .watch(itemRepositoryProvider)
      .watchItemsByCollection(collectionId);
}

/// Watches item count for a collection.
@riverpod
Stream<int> itemCountStream(
  ItemCountStreamRef ref,
  String collectionId,
) {
  return ref
      .watch(itemRepositoryProvider)
      .watchItemCount(collectionId);
}
