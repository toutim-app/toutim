import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/collection.dart';
import '../../../data/providers/repository_providers.dart';

part 'home_providers.g.dart';

/// Watches all collections for the home screen.
@riverpod
Stream<List<Collection>> collectionsStream(CollectionsStreamRef ref) {
  return ref.watch(collectionRepositoryProvider).watchAllCollections();
}
