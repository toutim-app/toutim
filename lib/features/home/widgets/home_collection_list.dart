import 'package:flutter/material.dart';

import '../../../data/models/collection.dart';
import 'collection_card.dart';

/// Scrollable list of collection cards for the home screen.
class HomeCollectionList extends StatelessWidget {
  final List<Collection> collections;

  const HomeCollectionList({super.key, required this.collections});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: collections.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final collection = collections[index];
        return CollectionCard(
          collection: collection,
          // Collection detail screen will be added in Phase 3
        );
      },
    );
  }
}
