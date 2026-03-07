import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/collection.dart';
import '../../../data/models/item_with_fields.dart';
import '../../../data/providers/repository_providers.dart';

part 'search_providers.g.dart';

/// Current search query text.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Aggregated search results.
class SearchResults {
  final List<Collection> collections;
  final List<ItemWithFields> items;

  const SearchResults({required this.collections, required this.items});

  bool get isEmpty => collections.isEmpty && items.isEmpty;
}

/// Searches collections and items matching the query.
@riverpod
Future<SearchResults> searchResults(SearchResultsRef ref) async {
  final query = ref.watch(searchQueryProvider).trim();
  if (query.length < 2) {
    return const SearchResults(collections: [], items: []);
  }

  final results = await Future.wait([
    ref.watch(collectionRepositoryProvider).searchCollections(query),
    ref.watch(itemRepositoryProvider).searchItems(query),
  ]);

  return SearchResults(
    collections: results[0] as List<Collection>,
    items: results[1] as List<ItemWithFields>,
  );
}
