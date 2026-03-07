import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../datasources/local/collection_local_datasource.dart';
import '../datasources/local/item_local_datasource.dart';
import 'database_provider.dart';

part 'datasource_providers.g.dart';

@Riverpod(keepAlive: true)
CollectionLocalDataSource collectionLocalDataSource(
    CollectionLocalDataSourceRef ref) {
  return CollectionLocalDataSource(ref.watch(appDatabaseProvider));
}

@Riverpod(keepAlive: true)
ItemLocalDataSource itemLocalDataSource(ItemLocalDataSourceRef ref) {
  return ItemLocalDataSource(ref.watch(appDatabaseProvider));
}
