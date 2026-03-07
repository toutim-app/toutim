// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$collectionsStreamHash() => r'2c9de8baaced95aef242c00c3a9d15a73938a416';

/// Watches all collections for the home screen.
///
/// Copied from [collectionsStream].
@ProviderFor(collectionsStream)
final collectionsStreamProvider =
    AutoDisposeStreamProvider<List<Collection>>.internal(
      collectionsStream,
      name: r'collectionsStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$collectionsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CollectionsStreamRef = AutoDisposeStreamProviderRef<List<Collection>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
