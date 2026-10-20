// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Watches all items with their field values for a collection.

@ProviderFor(allItemsWithFieldsStream)
final allItemsWithFieldsStreamProvider = AllItemsWithFieldsStreamFamily._();

/// Watches all items with their field values for a collection.

final class AllItemsWithFieldsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ItemWithFields>>,
          List<ItemWithFields>,
          Stream<List<ItemWithFields>>
        >
    with
        $FutureModifier<List<ItemWithFields>>,
        $StreamProvider<List<ItemWithFields>> {
  /// Watches all items with their field values for a collection.
  AllItemsWithFieldsStreamProvider._({
    required AllItemsWithFieldsStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'allItemsWithFieldsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$allItemsWithFieldsStreamHash();

  @override
  String toString() {
    return r'allItemsWithFieldsStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ItemWithFields>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ItemWithFields>> create(Ref ref) {
    final argument = this.argument as String;
    return allItemsWithFieldsStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AllItemsWithFieldsStreamProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$allItemsWithFieldsStreamHash() =>
    r'e3216223683de633e8484d84019b723ad9d51971';

/// Watches all items with their field values for a collection.

final class AllItemsWithFieldsStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ItemWithFields>>, String> {
  AllItemsWithFieldsStreamFamily._()
    : super(
        retry: null,
        name: r'allItemsWithFieldsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Watches all items with their field values for a collection.

  AllItemsWithFieldsStreamProvider call(String collectionId) =>
      AllItemsWithFieldsStreamProvider._(argument: collectionId, from: this);

  @override
  String toString() => r'allItemsWithFieldsStreamProvider';
}

/// Extracts field definitions that can be used as filters.
/// - select/multiSelect: require predefined options in field definition
/// - tags: always filterable (options are derived from item values at runtime)

@ProviderFor(filterableFields)
final filterableFieldsProvider = FilterableFieldsFamily._();

/// Extracts field definitions that can be used as filters.
/// - select/multiSelect: require predefined options in field definition
/// - tags: always filterable (options are derived from item values at runtime)

final class FilterableFieldsProvider
    extends
        $FunctionalProvider<
          List<FieldDefinition>,
          List<FieldDefinition>,
          List<FieldDefinition>
        >
    with $Provider<List<FieldDefinition>> {
  /// Extracts field definitions that can be used as filters.
  /// - select/multiSelect: require predefined options in field definition
  /// - tags: always filterable (options are derived from item values at runtime)
  FilterableFieldsProvider._({
    required FilterableFieldsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'filterableFieldsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filterableFieldsHash();

  @override
  String toString() {
    return r'filterableFieldsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<FieldDefinition>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<FieldDefinition> create(Ref ref) {
    final argument = this.argument as String;
    return filterableFields(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<FieldDefinition> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<FieldDefinition>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FilterableFieldsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filterableFieldsHash() => r'6786fd1e2cca5e5f9dd5883c299ce24710a08022';

/// Extracts field definitions that can be used as filters.
/// - select/multiSelect: require predefined options in field definition
/// - tags: always filterable (options are derived from item values at runtime)

final class FilterableFieldsFamily extends $Family
    with $FunctionalFamilyOverride<List<FieldDefinition>, String> {
  FilterableFieldsFamily._()
    : super(
        retry: null,
        name: r'filterableFieldsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Extracts field definitions that can be used as filters.
  /// - select/multiSelect: require predefined options in field definition
  /// - tags: always filterable (options are derived from item values at runtime)

  FilterableFieldsProvider call(String collectionId) =>
      FilterableFieldsProvider._(argument: collectionId, from: this);

  @override
  String toString() => r'filterableFieldsProvider';
}

/// Collects unique tag values used across all items for each tags field.
/// Returns a map of fieldDefinitionId -> sorted list of unique tag strings.

@ProviderFor(uniqueTagValues)
final uniqueTagValuesProvider = UniqueTagValuesFamily._();

/// Collects unique tag values used across all items for each tags field.
/// Returns a map of fieldDefinitionId -> sorted list of unique tag strings.

final class UniqueTagValuesProvider
    extends
        $FunctionalProvider<
          Map<String, List<String>>,
          Map<String, List<String>>,
          Map<String, List<String>>
        >
    with $Provider<Map<String, List<String>>> {
  /// Collects unique tag values used across all items for each tags field.
  /// Returns a map of fieldDefinitionId -> sorted list of unique tag strings.
  UniqueTagValuesProvider._({
    required UniqueTagValuesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'uniqueTagValuesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$uniqueTagValuesHash();

  @override
  String toString() {
    return r'uniqueTagValuesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Map<String, List<String>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, List<String>> create(Ref ref) {
    final argument = this.argument as String;
    return uniqueTagValues(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, List<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, List<String>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UniqueTagValuesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$uniqueTagValuesHash() => r'e78b5db23c85b50ca56477297fe2608411e448a2';

/// Collects unique tag values used across all items for each tags field.
/// Returns a map of fieldDefinitionId -> sorted list of unique tag strings.

final class UniqueTagValuesFamily extends $Family
    with $FunctionalFamilyOverride<Map<String, List<String>>, String> {
  UniqueTagValuesFamily._()
    : super(
        retry: null,
        name: r'uniqueTagValuesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Collects unique tag values used across all items for each tags field.
  /// Returns a map of fieldDefinitionId -> sorted list of unique tag strings.

  UniqueTagValuesProvider call(String collectionId) =>
      UniqueTagValuesProvider._(argument: collectionId, from: this);

  @override
  String toString() => r'uniqueTagValuesProvider';
}

/// Provides the filtered list of items.
/// OR logic within a field, AND logic between fields.

@ProviderFor(filteredItems)
final filteredItemsProvider = FilteredItemsFamily._();

/// Provides the filtered list of items.
/// OR logic within a field, AND logic between fields.

final class FilteredItemsProvider
    extends
        $FunctionalProvider<
          List<ItemWithFields>,
          List<ItemWithFields>,
          List<ItemWithFields>
        >
    with $Provider<List<ItemWithFields>> {
  /// Provides the filtered list of items.
  /// OR logic within a field, AND logic between fields.
  FilteredItemsProvider._({
    required FilteredItemsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'filteredItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filteredItemsHash();

  @override
  String toString() {
    return r'filteredItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<ItemWithFields>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<ItemWithFields> create(Ref ref) {
    final argument = this.argument as String;
    return filteredItems(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ItemWithFields> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ItemWithFields>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filteredItemsHash() => r'0965b6f1400e0ace4b69d648ece17d22142d0294';

/// Provides the filtered list of items.
/// OR logic within a field, AND logic between fields.

final class FilteredItemsFamily extends $Family
    with $FunctionalFamilyOverride<List<ItemWithFields>, String> {
  FilteredItemsFamily._()
    : super(
        retry: null,
        name: r'filteredItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides the filtered list of items.
  /// OR logic within a field, AND logic between fields.

  FilteredItemsProvider call(String collectionId) =>
      FilteredItemsProvider._(argument: collectionId, from: this);

  @override
  String toString() => r'filteredItemsProvider';
}
