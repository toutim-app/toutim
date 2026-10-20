// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Watches all collections for the home screen.

@ProviderFor(collectionsStream)
final collectionsStreamProvider = CollectionsStreamProvider._();

/// Watches all collections for the home screen.

final class CollectionsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Collection>>,
          List<Collection>,
          Stream<List<Collection>>
        >
    with $FutureModifier<List<Collection>>, $StreamProvider<List<Collection>> {
  /// Watches all collections for the home screen.
  CollectionsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<Collection>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Collection>> create(Ref ref) {
    return collectionsStream(ref);
  }
}

String _$collectionsStreamHash() => r'974953fa8c9662f4274ec5aa5cde7c1813503f30';
