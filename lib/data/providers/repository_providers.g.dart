// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [CollectionRepository] implementation.

@ProviderFor(collectionRepository)
final collectionRepositoryProvider = CollectionRepositoryProvider._();

/// Provides the [CollectionRepository] implementation.

final class CollectionRepositoryProvider
    extends
        $FunctionalProvider<
          CollectionRepository,
          CollectionRepository,
          CollectionRepository
        >
    with $Provider<CollectionRepository> {
  /// Provides the [CollectionRepository] implementation.
  CollectionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionRepositoryHash();

  @$internal
  @override
  $ProviderElement<CollectionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CollectionRepository create(Ref ref) {
    return collectionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CollectionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CollectionRepository>(value),
    );
  }
}

String _$collectionRepositoryHash() =>
    r'635e08b96ef5840d8341f55c68a8d37472e3fb66';

/// Provides the [ItemRepository] implementation.

@ProviderFor(itemRepository)
final itemRepositoryProvider = ItemRepositoryProvider._();

/// Provides the [ItemRepository] implementation.

final class ItemRepositoryProvider
    extends $FunctionalProvider<ItemRepository, ItemRepository, ItemRepository>
    with $Provider<ItemRepository> {
  /// Provides the [ItemRepository] implementation.
  ItemRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'itemRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$itemRepositoryHash();

  @$internal
  @override
  $ProviderElement<ItemRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ItemRepository create(Ref ref) {
    return itemRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ItemRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ItemRepository>(value),
    );
  }
}

String _$itemRepositoryHash() => r'fc7249b90be3d3252474afb8bd204142b869c2c4';

/// Provides the [SyncRepository] implementation.

@ProviderFor(syncRepository)
final syncRepositoryProvider = SyncRepositoryProvider._();

/// Provides the [SyncRepository] implementation.

final class SyncRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<SyncRepository>,
          SyncRepository,
          FutureOr<SyncRepository>
        >
    with $FutureModifier<SyncRepository>, $FutureProvider<SyncRepository> {
  /// Provides the [SyncRepository] implementation.
  SyncRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<SyncRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SyncRepository> create(Ref ref) {
    return syncRepository(ref);
  }
}

String _$syncRepositoryHash() => r'405fc8f4fa12fdad983c65dc49c079d865f3ab50';
