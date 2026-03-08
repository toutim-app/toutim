// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datasource_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$collectionLocalDataSourceHash() =>
    r'70e9f9c0399c769aa36bb2a5c528c040d1706e96';

/// See also [collectionLocalDataSource].
@ProviderFor(collectionLocalDataSource)
final collectionLocalDataSourceProvider =
    Provider<CollectionLocalDataSource>.internal(
      collectionLocalDataSource,
      name: r'collectionLocalDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$collectionLocalDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CollectionLocalDataSourceRef = ProviderRef<CollectionLocalDataSource>;
String _$itemLocalDataSourceHash() =>
    r'95c4d6cbccbfbaa3797f4ef66c0395758b5d6ffd';

/// See also [itemLocalDataSource].
@ProviderFor(itemLocalDataSource)
final itemLocalDataSourceProvider = Provider<ItemLocalDataSource>.internal(
  itemLocalDataSource,
  name: r'itemLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$itemLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ItemLocalDataSourceRef = ProviderRef<ItemLocalDataSource>;
String _$sharedPreferencesHash() => r'd0f94d4bd61259b4c06d24df95d1afc7eb5bd1c6';

/// Provides SharedPreferences instance.
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = FutureProvider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = FutureProviderRef<SharedPreferences>;
String _$secureStorageHash() => r'1803ee54eebc4038de1cd19ff9f0850676721a7f';

/// Provides FlutterSecureStorage instance.
///
/// Copied from [secureStorage].
@ProviderFor(secureStorage)
final secureStorageProvider = Provider<FlutterSecureStorage>.internal(
  secureStorage,
  name: r'secureStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$secureStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SecureStorageRef = ProviderRef<FlutterSecureStorage>;
String _$apiClientHash() => r'0e7e444c1a34b05ea5f4fcd86d5c3655a31820cb';

/// Provides the API client for server communication.
///
/// Copied from [apiClient].
@ProviderFor(apiClient)
final apiClientProvider = FutureProvider<ApiClient>.internal(
  apiClient,
  name: r'apiClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$apiClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApiClientRef = FutureProviderRef<ApiClient>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
