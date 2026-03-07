// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fieldDefinitionsStreamHash() =>
    r'23f69c1585c4ab26dff1461fde1c79acf6afc8b6';

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

/// Watches field definitions for a specific collection.
///
/// Copied from [fieldDefinitionsStream].
@ProviderFor(fieldDefinitionsStream)
const fieldDefinitionsStreamProvider = FieldDefinitionsStreamFamily();

/// Watches field definitions for a specific collection.
///
/// Copied from [fieldDefinitionsStream].
class FieldDefinitionsStreamFamily
    extends Family<AsyncValue<List<FieldDefinition>>> {
  /// Watches field definitions for a specific collection.
  ///
  /// Copied from [fieldDefinitionsStream].
  const FieldDefinitionsStreamFamily();

  /// Watches field definitions for a specific collection.
  ///
  /// Copied from [fieldDefinitionsStream].
  FieldDefinitionsStreamProvider call(String collectionId) {
    return FieldDefinitionsStreamProvider(collectionId);
  }

  @override
  FieldDefinitionsStreamProvider getProviderOverride(
    covariant FieldDefinitionsStreamProvider provider,
  ) {
    return call(provider.collectionId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fieldDefinitionsStreamProvider';
}

/// Watches field definitions for a specific collection.
///
/// Copied from [fieldDefinitionsStream].
class FieldDefinitionsStreamProvider
    extends AutoDisposeStreamProvider<List<FieldDefinition>> {
  /// Watches field definitions for a specific collection.
  ///
  /// Copied from [fieldDefinitionsStream].
  FieldDefinitionsStreamProvider(String collectionId)
    : this._internal(
        (ref) => fieldDefinitionsStream(
          ref as FieldDefinitionsStreamRef,
          collectionId,
        ),
        from: fieldDefinitionsStreamProvider,
        name: r'fieldDefinitionsStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$fieldDefinitionsStreamHash,
        dependencies: FieldDefinitionsStreamFamily._dependencies,
        allTransitiveDependencies:
            FieldDefinitionsStreamFamily._allTransitiveDependencies,
        collectionId: collectionId,
      );

  FieldDefinitionsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.collectionId,
  }) : super.internal();

  final String collectionId;

  @override
  Override overrideWith(
    Stream<List<FieldDefinition>> Function(FieldDefinitionsStreamRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FieldDefinitionsStreamProvider._internal(
        (ref) => create(ref as FieldDefinitionsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        collectionId: collectionId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<FieldDefinition>> createElement() {
    return _FieldDefinitionsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FieldDefinitionsStreamProvider &&
        other.collectionId == collectionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, collectionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FieldDefinitionsStreamRef
    on AutoDisposeStreamProviderRef<List<FieldDefinition>> {
  /// The parameter `collectionId` of this provider.
  String get collectionId;
}

class _FieldDefinitionsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<FieldDefinition>>
    with FieldDefinitionsStreamRef {
  _FieldDefinitionsStreamProviderElement(super.provider);

  @override
  String get collectionId =>
      (origin as FieldDefinitionsStreamProvider).collectionId;
}

String _$itemsStreamHash() => r'd0d2e55711023bc0f4781234354e5b828a0a6737';

/// Watches items for a specific collection.
///
/// Copied from [itemsStream].
@ProviderFor(itemsStream)
const itemsStreamProvider = ItemsStreamFamily();

/// Watches items for a specific collection.
///
/// Copied from [itemsStream].
class ItemsStreamFamily extends Family<AsyncValue<List<Item>>> {
  /// Watches items for a specific collection.
  ///
  /// Copied from [itemsStream].
  const ItemsStreamFamily();

  /// Watches items for a specific collection.
  ///
  /// Copied from [itemsStream].
  ItemsStreamProvider call(String collectionId) {
    return ItemsStreamProvider(collectionId);
  }

  @override
  ItemsStreamProvider getProviderOverride(
    covariant ItemsStreamProvider provider,
  ) {
    return call(provider.collectionId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'itemsStreamProvider';
}

/// Watches items for a specific collection.
///
/// Copied from [itemsStream].
class ItemsStreamProvider extends AutoDisposeStreamProvider<List<Item>> {
  /// Watches items for a specific collection.
  ///
  /// Copied from [itemsStream].
  ItemsStreamProvider(String collectionId)
    : this._internal(
        (ref) => itemsStream(ref as ItemsStreamRef, collectionId),
        from: itemsStreamProvider,
        name: r'itemsStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$itemsStreamHash,
        dependencies: ItemsStreamFamily._dependencies,
        allTransitiveDependencies: ItemsStreamFamily._allTransitiveDependencies,
        collectionId: collectionId,
      );

  ItemsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.collectionId,
  }) : super.internal();

  final String collectionId;

  @override
  Override overrideWith(
    Stream<List<Item>> Function(ItemsStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ItemsStreamProvider._internal(
        (ref) => create(ref as ItemsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        collectionId: collectionId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Item>> createElement() {
    return _ItemsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemsStreamProvider && other.collectionId == collectionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, collectionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ItemsStreamRef on AutoDisposeStreamProviderRef<List<Item>> {
  /// The parameter `collectionId` of this provider.
  String get collectionId;
}

class _ItemsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Item>>
    with ItemsStreamRef {
  _ItemsStreamProviderElement(super.provider);

  @override
  String get collectionId => (origin as ItemsStreamProvider).collectionId;
}

String _$itemCountStreamHash() => r'd90d66a4b0f8fd0df777ab26260cec5a7615a08c';

/// Watches item count for a collection.
///
/// Copied from [itemCountStream].
@ProviderFor(itemCountStream)
const itemCountStreamProvider = ItemCountStreamFamily();

/// Watches item count for a collection.
///
/// Copied from [itemCountStream].
class ItemCountStreamFamily extends Family<AsyncValue<int>> {
  /// Watches item count for a collection.
  ///
  /// Copied from [itemCountStream].
  const ItemCountStreamFamily();

  /// Watches item count for a collection.
  ///
  /// Copied from [itemCountStream].
  ItemCountStreamProvider call(String collectionId) {
    return ItemCountStreamProvider(collectionId);
  }

  @override
  ItemCountStreamProvider getProviderOverride(
    covariant ItemCountStreamProvider provider,
  ) {
    return call(provider.collectionId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'itemCountStreamProvider';
}

/// Watches item count for a collection.
///
/// Copied from [itemCountStream].
class ItemCountStreamProvider extends AutoDisposeStreamProvider<int> {
  /// Watches item count for a collection.
  ///
  /// Copied from [itemCountStream].
  ItemCountStreamProvider(String collectionId)
    : this._internal(
        (ref) => itemCountStream(ref as ItemCountStreamRef, collectionId),
        from: itemCountStreamProvider,
        name: r'itemCountStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$itemCountStreamHash,
        dependencies: ItemCountStreamFamily._dependencies,
        allTransitiveDependencies:
            ItemCountStreamFamily._allTransitiveDependencies,
        collectionId: collectionId,
      );

  ItemCountStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.collectionId,
  }) : super.internal();

  final String collectionId;

  @override
  Override overrideWith(
    Stream<int> Function(ItemCountStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ItemCountStreamProvider._internal(
        (ref) => create(ref as ItemCountStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        collectionId: collectionId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<int> createElement() {
    return _ItemCountStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemCountStreamProvider &&
        other.collectionId == collectionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, collectionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ItemCountStreamRef on AutoDisposeStreamProviderRef<int> {
  /// The parameter `collectionId` of this provider.
  String get collectionId;
}

class _ItemCountStreamProviderElement
    extends AutoDisposeStreamProviderElement<int>
    with ItemCountStreamRef {
  _ItemCountStreamProviderElement(super.provider);

  @override
  String get collectionId => (origin as ItemCountStreamProvider).collectionId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
