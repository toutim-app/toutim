import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/collection_repository.dart';
import '../repositories/collection_repository_impl.dart';
import '../repositories/item_repository.dart';
import '../repositories/item_repository_impl.dart';
import '../repositories/sync_repository.dart';
import '../repositories/sync_repository_impl.dart';
import 'datasource_providers.dart';

part 'repository_providers.g.dart';

/// Provides the [CollectionRepository] implementation.
@Riverpod(keepAlive: true)
CollectionRepository collectionRepository(Ref ref) {
  return CollectionRepositoryImpl(
      ref.watch(collectionLocalDataSourceProvider));
}

/// Provides the [ItemRepository] implementation.
@Riverpod(keepAlive: true)
ItemRepository itemRepository(Ref ref) {
  return ItemRepositoryImpl(ref.watch(itemLocalDataSourceProvider));
}

/// Provides the [SyncRepository] implementation.
@Riverpod(keepAlive: true)
Future<SyncRepository> syncRepository(Ref ref) async {
  final apiClient = await ref.watch(apiClientProvider.future);
  final collectionDs = ref.watch(collectionLocalDataSourceProvider);
  final itemDs = ref.watch(itemLocalDataSourceProvider);
  return SyncRepositoryImpl(
    apiClient: apiClient,
    collectionDs: collectionDs,
    itemDs: itemDs,
  );
}
