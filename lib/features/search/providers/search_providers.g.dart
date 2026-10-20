// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Searches collections and items matching the query.

@ProviderFor(searchResults)
final searchResultsProvider = SearchResultsProvider._();

/// Searches collections and items matching the query.

final class SearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<SearchResults>,
          SearchResults,
          FutureOr<SearchResults>
        >
    with $FutureModifier<SearchResults>, $FutureProvider<SearchResults> {
  /// Searches collections and items matching the query.
  SearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @$internal
  @override
  $FutureProviderElement<SearchResults> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SearchResults> create(Ref ref) {
    return searchResults(ref);
  }
}

String _$searchResultsHash() => r'5d94d083dfe23ee2a8da848e1a5112e8f50f78d9';
