import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/collection.dart';
import '../../../data/providers/repository_providers.dart';
import 'collection_card.dart';

/// Scrollable, reorderable list of collection cards for the home screen.
class HomeCollectionList extends ConsumerWidget {
  final List<Collection> collections;

  const HomeCollectionList({super.key, required this.collections});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: collections.length,
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(16),
            color: Colors.transparent,
            child: child,
          ),
          child: child,
        );
      },
      onReorder: (oldIndex, newIndex) {
        if (newIndex > oldIndex) newIndex--;
        final reordered = [...collections];
        final item = reordered.removeAt(oldIndex);
        reordered.insert(newIndex, item);

        final updated = <Collection>[];
        for (var i = 0; i < reordered.length; i++) {
          updated.add(reordered[i].copyWith(sortOrder: i));
        }
        ref.read(collectionRepositoryProvider).reorderCollections(updated);
      },
      itemBuilder: (context, index) {
        final collection = collections[index];
        return Padding(
          key: ValueKey(collection.id),
          padding: const EdgeInsets.only(bottom: 12),
          child: CollectionCard(
            collection: collection,
            onTap: () => context.push('/collection/${collection.id}'),
          ),
        );
      },
    );
  }
}
