// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$itemWithFieldsStreamHash() =>
    r'a125df4e805672ca13e07382797fcf9e073c395e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Watches a single item with all its field values.
///
/// Copied from [itemWithFieldsStream].
@ProviderFor(itemWithFieldsStream)
const itemWithFieldsStreamProvider = ItemWithFieldsStreamFamily();

/// Watches a single item with all its field values.
///
/// Copied from [itemWithFieldsStream].
class ItemWithFieldsStreamFamily extends Family<AsyncValue<ItemWithFields?>> {
  /// Watches a single item with all its field values.
  ///
  /// Copied from [itemWithFieldsStream].
  const ItemWithFieldsStreamFamily();

  /// Watches a single item with all its field values.
  ///
  /// Copied from [itemWithFieldsStream].
  ItemWithFieldsStreamProvider call(String itemId) {
    return ItemWithFieldsStreamProvider(itemId);
  }

  @override
  ItemWithFieldsStreamProvider getProviderOverride(
    covariant ItemWithFieldsStreamProvider provider,
  ) {
    return call(provider.itemId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'itemWithFieldsStreamProvider';
}

/// Watches a single item with all its field values.
///
/// Copied from [itemWithFieldsStream].
class ItemWithFieldsStreamProvider
    extends AutoDisposeStreamProvider<ItemWithFields?> {
  /// Watches a single item with all its field values.
  ///
  /// Copied from [itemWithFieldsStream].
  ItemWithFieldsStreamProvider(String itemId)
    : this._internal(
        (ref) => itemWithFieldsStream(ref as ItemWithFieldsStreamRef, itemId),
        from: itemWithFieldsStreamProvider,
        name: r'itemWithFieldsStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$itemWithFieldsStreamHash,
        dependencies: ItemWithFieldsStreamFamily._dependencies,
        allTransitiveDependencies:
            ItemWithFieldsStreamFamily._allTransitiveDependencies,
        itemId: itemId,
      );

  ItemWithFieldsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemId,
  }) : super.internal();

  final String itemId;

  @override
  Override overrideWith(
    Stream<ItemWithFields?> Function(ItemWithFieldsStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ItemWithFieldsStreamProvider._internal(
        (ref) => create(ref as ItemWithFieldsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemId: itemId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<ItemWithFields?> createElement() {
    return _ItemWithFieldsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemWithFieldsStreamProvider && other.itemId == itemId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ItemWithFieldsStreamRef on AutoDisposeStreamProviderRef<ItemWithFields?> {
  /// The parameter `itemId` of this provider.
  String get itemId;
}

class _ItemWithFieldsStreamProviderElement
    extends AutoDisposeStreamProviderElement<ItemWithFields?>
    with ItemWithFieldsStreamRef {
  _ItemWithFieldsStreamProviderElement(super.provider);

  @override
  String get itemId => (origin as ItemWithFieldsStreamProvider).itemId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
