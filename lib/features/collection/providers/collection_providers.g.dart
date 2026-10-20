// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches a single collection by id.

@ProviderFor(collectionById)
final collectionByIdProvider = CollectionByIdFamily._();

/// Fetches a single collection by id.

final class CollectionByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Collection?>,
          Collection?,
          FutureOr<Collection?>
        >
    with $FutureModifier<Collection?>, $FutureProvider<Collection?> {
  /// Fetches a single collection by id.
  CollectionByIdProvider._({
    required CollectionByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'collectionByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$collectionByIdHash();

  @override
  String toString() {
    return r'collectionByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Collection?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Collection?> create(Ref ref) {
    final argument = this.argument as String;
    return collectionById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CollectionByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$collectionByIdHash() => r'7c5f4eaf3a5475731b95693a2d512c396ea93456';

/// Fetches a single collection by id.

final class CollectionByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Collection?>, String> {
  CollectionByIdFamily._()
    : super(
        retry: null,
        name: r'collectionByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches a single collection by id.

  CollectionByIdProvider call(String collectionId) =>
      CollectionByIdProvider._(argument: collectionId, from: this);

  @override
  String toString() => r'collectionByIdProvider';
}

/// Watches field definitions for a specific collection.

@ProviderFor(fieldDefinitionsStream)
final fieldDefinitionsStreamProvider = FieldDefinitionsStreamFamily._();

/// Watches field definitions for a specific collection.

final class FieldDefinitionsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FieldDefinition>>,
          List<FieldDefinition>,
          Stream<List<FieldDefinition>>
        >
    with
        $FutureModifier<List<FieldDefinition>>,
        $StreamProvider<List<FieldDefinition>> {
  /// Watches field definitions for a specific collection.
  FieldDefinitionsStreamProvider._({
    required FieldDefinitionsStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'fieldDefinitionsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fieldDefinitionsStreamHash();

  @override
  String toString() {
    return r'fieldDefinitionsStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<FieldDefinition>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<FieldDefinition>> create(Ref ref) {
    final argument = this.argument as String;
    return fieldDefinitionsStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FieldDefinitionsStreamProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fieldDefinitionsStreamHash() =>
    r'7bab79d7ef3bd60ccada9979c19fce4d46b16f85';

/// Watches field definitions for a specific collection.

final class FieldDefinitionsStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<FieldDefinition>>, String> {
  FieldDefinitionsStreamFamily._()
    : super(
        retry: null,
        name: r'fieldDefinitionsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Watches field definitions for a specific collection.

  FieldDefinitionsStreamProvider call(String collectionId) =>
      FieldDefinitionsStreamProvider._(argument: collectionId, from: this);

  @override
  String toString() => r'fieldDefinitionsStreamProvider';
}

/// Watches items for a specific collection.

@ProviderFor(itemsStream)
final itemsStreamProvider = ItemsStreamFamily._();

/// Watches items for a specific collection.

final class ItemsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Item>>,
          List<Item>,
          Stream<List<Item>>
        >
    with $FutureModifier<List<Item>>, $StreamProvider<List<Item>> {
  /// Watches items for a specific collection.
  ItemsStreamProvider._({
    required ItemsStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'itemsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$itemsStreamHash();

  @override
  String toString() {
    return r'itemsStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Item>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Item>> create(Ref ref) {
    final argument = this.argument as String;
    return itemsStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemsStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$itemsStreamHash() => r'b2c63c09f2950e22f82476f2f982a09902e1547f';

/// Watches items for a specific collection.

final class ItemsStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Item>>, String> {
  ItemsStreamFamily._()
    : super(
        retry: null,
        name: r'itemsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Watches items for a specific collection.

  ItemsStreamProvider call(String collectionId) =>
      ItemsStreamProvider._(argument: collectionId, from: this);

  @override
  String toString() => r'itemsStreamProvider';
}

/// Watches item count for a collection.

@ProviderFor(itemCountStream)
final itemCountStreamProvider = ItemCountStreamFamily._();

/// Watches item count for a collection.

final class ItemCountStreamProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Watches item count for a collection.
  ItemCountStreamProvider._({
    required ItemCountStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'itemCountStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$itemCountStreamHash();

  @override
  String toString() {
    return r'itemCountStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    final argument = this.argument as String;
    return itemCountStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemCountStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$itemCountStreamHash() => r'3fdf25c85b96c75a3db225a9f4748ae18b5e4f76';

/// Watches item count for a collection.

final class ItemCountStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, String> {
  ItemCountStreamFamily._()
    : super(
        retry: null,
        name: r'itemCountStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Watches item count for a collection.

  ItemCountStreamProvider call(String collectionId) =>
      ItemCountStreamProvider._(argument: collectionId, from: this);

  @override
  String toString() => r'itemCountStreamProvider';
}
