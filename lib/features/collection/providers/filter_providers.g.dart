// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allItemsWithFieldsStreamHash() =>
    r'9492bd2052336542913050a69a72c1412bbb2f8a';

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

/// Watches all items with their field values for a collection.
///
/// Copied from [allItemsWithFieldsStream].
@ProviderFor(allItemsWithFieldsStream)
const allItemsWithFieldsStreamProvider = AllItemsWithFieldsStreamFamily();

/// Watches all items with their field values for a collection.
///
/// Copied from [allItemsWithFieldsStream].
class AllItemsWithFieldsStreamFamily
    extends Family<AsyncValue<List<ItemWithFields>>> {
  /// Watches all items with their field values for a collection.
  ///
  /// Copied from [allItemsWithFieldsStream].
  const AllItemsWithFieldsStreamFamily();

  /// Watches all items with their field values for a collection.
  ///
  /// Copied from [allItemsWithFieldsStream].
  AllItemsWithFieldsStreamProvider call(String collectionId) {
    return AllItemsWithFieldsStreamProvider(collectionId);
  }

  @override
  AllItemsWithFieldsStreamProvider getProviderOverride(
    covariant AllItemsWithFieldsStreamProvider provider,
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
  String? get name => r'allItemsWithFieldsStreamProvider';
}

/// Watches all items with their field values for a collection.
///
/// Copied from [allItemsWithFieldsStream].
class AllItemsWithFieldsStreamProvider
    extends AutoDisposeStreamProvider<List<ItemWithFields>> {
  /// Watches all items with their field values for a collection.
  ///
  /// Copied from [allItemsWithFieldsStream].
  AllItemsWithFieldsStreamProvider(String collectionId)
    : this._internal(
        (ref) => allItemsWithFieldsStream(
          ref as AllItemsWithFieldsStreamRef,
          collectionId,
        ),
        from: allItemsWithFieldsStreamProvider,
        name: r'allItemsWithFieldsStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$allItemsWithFieldsStreamHash,
        dependencies: AllItemsWithFieldsStreamFamily._dependencies,
        allTransitiveDependencies:
            AllItemsWithFieldsStreamFamily._allTransitiveDependencies,
        collectionId: collectionId,
      );

  AllItemsWithFieldsStreamProvider._internal(
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
    Stream<List<ItemWithFields>> Function(AllItemsWithFieldsStreamRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllItemsWithFieldsStreamProvider._internal(
        (ref) => create(ref as AllItemsWithFieldsStreamRef),
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
  AutoDisposeStreamProviderElement<List<ItemWithFields>> createElement() {
    return _AllItemsWithFieldsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllItemsWithFieldsStreamProvider &&
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
mixin AllItemsWithFieldsStreamRef
    on AutoDisposeStreamProviderRef<List<ItemWithFields>> {
  /// The parameter `collectionId` of this provider.
  String get collectionId;
}

class _AllItemsWithFieldsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<ItemWithFields>>
    with AllItemsWithFieldsStreamRef {
  _AllItemsWithFieldsStreamProviderElement(super.provider);

  @override
  String get collectionId =>
      (origin as AllItemsWithFieldsStreamProvider).collectionId;
}

String _$filterableFieldsHash() => r'f5c4249073e056ac4bec57fa8c8cbdcc3d8ceb98';

/// Extracts field definitions that can be used as filters.
///
/// Copied from [filterableFields].
@ProviderFor(filterableFields)
const filterableFieldsProvider = FilterableFieldsFamily();

/// Extracts field definitions that can be used as filters.
///
/// Copied from [filterableFields].
class FilterableFieldsFamily extends Family<List<FieldDefinition>> {
  /// Extracts field definitions that can be used as filters.
  ///
  /// Copied from [filterableFields].
  const FilterableFieldsFamily();

  /// Extracts field definitions that can be used as filters.
  ///
  /// Copied from [filterableFields].
  FilterableFieldsProvider call(String collectionId) {
    return FilterableFieldsProvider(collectionId);
  }

  @override
  FilterableFieldsProvider getProviderOverride(
    covariant FilterableFieldsProvider provider,
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
  String? get name => r'filterableFieldsProvider';
}

/// Extracts field definitions that can be used as filters.
///
/// Copied from [filterableFields].
class FilterableFieldsProvider
    extends AutoDisposeProvider<List<FieldDefinition>> {
  /// Extracts field definitions that can be used as filters.
  ///
  /// Copied from [filterableFields].
  FilterableFieldsProvider(String collectionId)
    : this._internal(
        (ref) => filterableFields(ref as FilterableFieldsRef, collectionId),
        from: filterableFieldsProvider,
        name: r'filterableFieldsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$filterableFieldsHash,
        dependencies: FilterableFieldsFamily._dependencies,
        allTransitiveDependencies:
            FilterableFieldsFamily._allTransitiveDependencies,
        collectionId: collectionId,
      );

  FilterableFieldsProvider._internal(
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
    List<FieldDefinition> Function(FilterableFieldsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilterableFieldsProvider._internal(
        (ref) => create(ref as FilterableFieldsRef),
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
  AutoDisposeProviderElement<List<FieldDefinition>> createElement() {
    return _FilterableFieldsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilterableFieldsProvider &&
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
mixin FilterableFieldsRef on AutoDisposeProviderRef<List<FieldDefinition>> {
  /// The parameter `collectionId` of this provider.
  String get collectionId;
}

class _FilterableFieldsProviderElement
    extends AutoDisposeProviderElement<List<FieldDefinition>>
    with FilterableFieldsRef {
  _FilterableFieldsProviderElement(super.provider);

  @override
  String get collectionId => (origin as FilterableFieldsProvider).collectionId;
}

String _$filteredItemsHash() => r'f911489ada062403b241bf7cf15d9c39ac1eb06b';

/// Provides the filtered list of items.
/// OR logic within a field, AND logic between fields.
///
/// Copied from [filteredItems].
@ProviderFor(filteredItems)
const filteredItemsProvider = FilteredItemsFamily();

/// Provides the filtered list of items.
/// OR logic within a field, AND logic between fields.
///
/// Copied from [filteredItems].
class FilteredItemsFamily extends Family<List<ItemWithFields>> {
  /// Provides the filtered list of items.
  /// OR logic within a field, AND logic between fields.
  ///
  /// Copied from [filteredItems].
  const FilteredItemsFamily();

  /// Provides the filtered list of items.
  /// OR logic within a field, AND logic between fields.
  ///
  /// Copied from [filteredItems].
  FilteredItemsProvider call(String collectionId) {
    return FilteredItemsProvider(collectionId);
  }

  @override
  FilteredItemsProvider getProviderOverride(
    covariant FilteredItemsProvider provider,
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
  String? get name => r'filteredItemsProvider';
}

/// Provides the filtered list of items.
/// OR logic within a field, AND logic between fields.
///
/// Copied from [filteredItems].
class FilteredItemsProvider extends AutoDisposeProvider<List<ItemWithFields>> {
  /// Provides the filtered list of items.
  /// OR logic within a field, AND logic between fields.
  ///
  /// Copied from [filteredItems].
  FilteredItemsProvider(String collectionId)
    : this._internal(
        (ref) => filteredItems(ref as FilteredItemsRef, collectionId),
        from: filteredItemsProvider,
        name: r'filteredItemsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$filteredItemsHash,
        dependencies: FilteredItemsFamily._dependencies,
        allTransitiveDependencies:
            FilteredItemsFamily._allTransitiveDependencies,
        collectionId: collectionId,
      );

  FilteredItemsProvider._internal(
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
    List<ItemWithFields> Function(FilteredItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredItemsProvider._internal(
        (ref) => create(ref as FilteredItemsRef),
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
  AutoDisposeProviderElement<List<ItemWithFields>> createElement() {
    return _FilteredItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredItemsProvider && other.collectionId == collectionId;
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
mixin FilteredItemsRef on AutoDisposeProviderRef<List<ItemWithFields>> {
  /// The parameter `collectionId` of this provider.
  String get collectionId;
}

class _FilteredItemsProviderElement
    extends AutoDisposeProviderElement<List<ItemWithFields>>
    with FilteredItemsRef {
  _FilteredItemsProviderElement(super.provider);

  @override
  String get collectionId => (origin as FilteredItemsProvider).collectionId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
