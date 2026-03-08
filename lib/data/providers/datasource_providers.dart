import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../datasources/local/collection_local_datasource.dart';
import '../datasources/local/item_local_datasource.dart';
import '../datasources/remote/api_client.dart';
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

/// Provides SharedPreferences instance.
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) {
  return SharedPreferences.getInstance();
}

/// Provides FlutterSecureStorage instance.
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  return const FlutterSecureStorage();
}

/// Provides the API client for server communication.
@Riverpod(keepAlive: true)
Future<ApiClient> apiClient(ApiClientRef ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  final secure = ref.watch(secureStorageProvider);
  return ApiClient(prefs: prefs, secureStorage: secure);
}
