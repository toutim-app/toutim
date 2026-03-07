import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/collection_repository.dart';
import '../repositories/collection_repository_impl.dart';
import '../repositories/item_repository.dart';
import '../repositories/item_repository_impl.dart';
import 'datasource_providers.dart';

part 'repository_providers.g.dart';

/// Provides the [CollectionRepository] implementation.
@Riverpod(keepAlive: true)
CollectionRepository collectionRepository(CollectionRepositoryRef ref) {
  return CollectionRepositoryImpl(
      ref.watch(collectionLocalDataSourceProvider));
}

/// Provides the [ItemRepository] implementation.
@Riverpod(keepAlive: true)
ItemRepository itemRepository(ItemRepositoryRef ref) {
  return ItemRepositoryImpl(ref.watch(itemLocalDataSourceProvider));
}
