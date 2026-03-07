import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/collection.dart' as models;
import '../../../data/providers/repository_providers.dart';
import '../../../data/repositories/collection_repository.dart';
import '../../../data/templates/collection_templates.dart';

part 'create_collection_provider.g.dart';

/// Service for creating collections from templates or custom input.
class CollectionCreationService {
  final CollectionRepository _repo;

  const CollectionCreationService(this._repo);

  /// Creates a collection from a pre-defined template with all its fields.
  Future<models.Collection> createFromTemplate(
      CollectionTemplate template) async {
    final collection = await _repo.createCollection(
      name: template.name,
      icon: template.emoji,
      color: template.colorKey,
      templateId: template.id,
      description: template.description,
    );

    for (var i = 0; i < template.fields.length; i++) {
      final f = template.fields[i];
      await _repo.addFieldDefinition(
        collectionId: collection.id,
        name: f.name,
        type: f.type,
        sortOrder: i,
        isRequired: f.isRequired,
        showInList: f.showInList,
        showInCard: f.showInCard,
        searchable: f.searchable,
        sortable: f.sortable,
        options: f.options,
      );
    }

    return collection;
  }

  /// Creates a custom empty collection.
  Future<models.Collection> createCustom({
    required String name,
    required String colorKey,
    String? icon,
    String? description,
  }) {
    return _repo.createCollection(
      name: name,
      icon: icon,
      color: colorKey,
      description: description,
    );
  }
}

@Riverpod(keepAlive: true)
CollectionCreationService collectionCreationService(
    CollectionCreationServiceRef ref) {
  return CollectionCreationService(ref.watch(collectionRepositoryProvider));
}
