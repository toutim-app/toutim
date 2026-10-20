// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Watches a single item with all its field values.

@ProviderFor(itemWithFieldsStream)
final itemWithFieldsStreamProvider = ItemWithFieldsStreamFamily._();

/// Watches a single item with all its field values.

final class ItemWithFieldsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<ItemWithFields?>,
          ItemWithFields?,
          Stream<ItemWithFields?>
        >
    with $FutureModifier<ItemWithFields?>, $StreamProvider<ItemWithFields?> {
  /// Watches a single item with all its field values.
  ItemWithFieldsStreamProvider._({
    required ItemWithFieldsStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'itemWithFieldsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$itemWithFieldsStreamHash();

  @override
  String toString() {
    return r'itemWithFieldsStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<ItemWithFields?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ItemWithFields?> create(Ref ref) {
    final argument = this.argument as String;
    return itemWithFieldsStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemWithFieldsStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$itemWithFieldsStreamHash() =>
    r'561a8388baefcd20a8ef4a546ad6609f37a36f7d';

/// Watches a single item with all its field values.

final class ItemWithFieldsStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<ItemWithFields?>, String> {
  ItemWithFieldsStreamFamily._()
    : super(
        retry: null,
        name: r'itemWithFieldsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Watches a single item with all its field values.

  ItemWithFieldsStreamProvider call(String itemId) =>
      ItemWithFieldsStreamProvider._(argument: itemId, from: this);

  @override
  String toString() => r'itemWithFieldsStreamProvider';
}
