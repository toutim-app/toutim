// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datasource_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(collectionLocalDataSource)
final collectionLocalDataSourceProvider = CollectionLocalDataSourceProvider._();

final class CollectionLocalDataSourceProvider
    extends
        $FunctionalProvider<
          CollectionLocalDataSource,
          CollectionLocalDataSource,
          CollectionLocalDataSource
        >
    with $Provider<CollectionLocalDataSource> {
  CollectionLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<CollectionLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CollectionLocalDataSource create(Ref ref) {
    return collectionLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CollectionLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CollectionLocalDataSource>(value),
    );
  }
}

String _$collectionLocalDataSourceHash() =>
    r'ccf9ca8342f6e421b5993eef6822c41d724f16fa';

@ProviderFor(itemLocalDataSource)
final itemLocalDataSourceProvider = ItemLocalDataSourceProvider._();

final class ItemLocalDataSourceProvider
    extends
        $FunctionalProvider<
          ItemLocalDataSource,
          ItemLocalDataSource,
          ItemLocalDataSource
        >
    with $Provider<ItemLocalDataSource> {
  ItemLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'itemLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$itemLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ItemLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ItemLocalDataSource create(Ref ref) {
    return itemLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ItemLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ItemLocalDataSource>(value),
    );
  }
}

String _$itemLocalDataSourceHash() =>
    r'540e49ba6c7eecc547a50c21a809e58361694c6c';

/// Provides SharedPreferences instance.

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// Provides SharedPreferences instance.

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedPreferences>,
          SharedPreferences,
          FutureOr<SharedPreferences>
        >
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  /// Provides SharedPreferences instance.
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return sharedPreferences(ref);
  }
}

String _$sharedPreferencesHash() => r'48e60558ea6530114ea20ea03e69b9fb339ab129';

/// Provides FlutterSecureStorage instance.

@ProviderFor(secureStorage)
final secureStorageProvider = SecureStorageProvider._();

/// Provides FlutterSecureStorage instance.

final class SecureStorageProvider
    extends
        $FunctionalProvider<
          FlutterSecureStorage,
          FlutterSecureStorage,
          FlutterSecureStorage
        >
    with $Provider<FlutterSecureStorage> {
  /// Provides FlutterSecureStorage instance.
  SecureStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageHash();

  @$internal
  @override
  $ProviderElement<FlutterSecureStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FlutterSecureStorage create(Ref ref) {
    return secureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlutterSecureStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlutterSecureStorage>(value),
    );
  }
}

String _$secureStorageHash() => r'a4f75721472cf77465bf47f759c90de5ca30856e';

/// Provides the API client for server communication.

@ProviderFor(apiClient)
final apiClientProvider = ApiClientProvider._();

/// Provides the API client for server communication.

final class ApiClientProvider
    extends
        $FunctionalProvider<
          AsyncValue<ApiClient>,
          ApiClient,
          FutureOr<ApiClient>
        >
    with $FutureModifier<ApiClient>, $FutureProvider<ApiClient> {
  /// Provides the API client for server communication.
  ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientHash();

  @$internal
  @override
  $FutureProviderElement<ApiClient> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ApiClient> create(Ref ref) {
    return apiClient(ref);
  }
}

String _$apiClientHash() => r'73fb571f46ba723d717763ef68f3fc714e10022a';
