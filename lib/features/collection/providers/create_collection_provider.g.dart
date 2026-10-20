// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_collection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(collectionCreationService)
final collectionCreationServiceProvider = CollectionCreationServiceProvider._();

final class CollectionCreationServiceProvider
    extends
        $FunctionalProvider<
          CollectionCreationService,
          CollectionCreationService,
          CollectionCreationService
        >
    with $Provider<CollectionCreationService> {
  CollectionCreationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionCreationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionCreationServiceHash();

  @$internal
  @override
  $ProviderElement<CollectionCreationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CollectionCreationService create(Ref ref) {
    return collectionCreationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CollectionCreationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CollectionCreationService>(value),
    );
  }
}

String _$collectionCreationServiceHash() =>
    r'7a6949249fbebbd94340eb104c776865ec38c4fb';
