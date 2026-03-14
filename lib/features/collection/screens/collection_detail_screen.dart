import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/extensions/collection_extensions.dart';
import '../../../core/extensions/color_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/repository_providers.dart';
import '../../settings/providers/auto_sync_providers.dart';
import '../providers/collection_providers.dart';
import '../providers/filter_providers.dart';
import '../../../data/models/collection.dart';
import '../widgets/collection_empty_state.dart';
import '../widgets/collection_filter_bar.dart';
import '../widgets/edit_collection_sheet.dart';
import '../widgets/item_card.dart';

/// Screen displaying the contents of a single collection.
class CollectionDetailScreen extends ConsumerWidget {
  final String collectionId;

  const CollectionDetailScreen({super.key, required this.collectionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionAsync = ref.watch(collectionByIdProvider(collectionId));
    final fieldsAsync = ref.watch(fieldDefinitionsStreamProvider(collectionId));
    final allItemsAsync =
        ref.watch(allItemsWithFieldsStreamProvider(collectionId));
    final filterableFieldsList =
        ref.watch(filterableFieldsProvider(collectionId));
    final filteredItemsList = ref.watch(filteredItemsProvider(collectionId));

    final collectionColor = collectionAsync.when(
      data: (c) => c?.resolvedColor ?? AppColors.blue,
      loading: () => AppColors.blue,
      error: (_, _) => AppColors.blue,
    );

    return Scaffold(
      appBar: AppBar(
        title: collectionAsync.when(
          data: (c) {
            if (c == null) return const Text('Collection');
            final emoji = c.icon ?? '';
            return Text('$emoji ${c.name}'.trim());
          },
          loading: () => const Text('...'),
          error: (_, _) => const Text('Erreur'),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(LucideIcons.moreVertical,
                color: context.appTextSecondary, size: 20),
            onSelected: (value) {
              if (value == 'edit') {
                final collection = collectionAsync.valueOrNull;
                if (collection != null) {
                  _showEditSheet(context, ref, collection);
                }
              } else if (value == 'fields') {
                context.push('/collection/$collectionId/fields');
              } else if (value == 'delete') {
                _confirmDeleteCollection(context, ref);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(LucideIcons.pencil,
                        size: 18, color: context.appTextSecondary),
                    const SizedBox(width: 8),
                    Text('Modifier'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'fields',
                child: Row(
                  children: [
                    Icon(LucideIcons.settings2,
                        size: 18, color: context.appTextSecondary),
                    const SizedBox(width: 8),
                    Text('Gérer les champs'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(LucideIcons.trash2, size: 18, color: AppColors.red),
                    const SizedBox(width: 8),
                    Text('Supprimer',
                        style: TextStyle(color: AppColors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: allItemsAsync.when(
        data: (allItems) {
          if (allItems.isEmpty) {
            return const CollectionEmptyState();
          }
          return fieldsAsync.when(
            data: (fields) => Column(
              children: [
                if (filterableFieldsList.isNotEmpty)
                  CollectionFilterBar(
                    collectionId: collectionId,
                    filterableFields: filterableFieldsList,
                    collectionColor: collectionColor,
                  ),
                Expanded(
                  child: filteredItemsList.isEmpty
                      ? _buildNoResultsState(context, ref)
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredItemsList.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final itemWithFields = filteredItemsList[index];
                            return Dismissible(
                              key: ValueKey(itemWithFields.item.id),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (_) =>
                                  _confirmDelete(context),
                              onDismissed: (_) {
                                ref
                                    .read(itemRepositoryProvider)
                                    .deleteItem(itemWithFields.item.id);
                                ref
                                    .read(syncTriggerProvider.notifier)
                                    .notifyDataChanged();
                              },
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: AppColors.red,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  LucideIcons.trash2,
                                  color: Colors.white,
                                ),
                              ),
                              child: ItemCard(
                                itemId: itemWithFields.item.id,
                                fieldDefinitions: fields,
                                collectionColor: collectionColor,
                                onTap: () => context.push(
                                  '/collection/$collectionId/item/${itemWithFields.item.id}',
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (_, _) => const SizedBox.shrink(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Une erreur est survenue',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.appTextSecondary,
                ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/collection/$collectionId/item/new'),
        backgroundColor: collectionColor,
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }

  Future<void> _showEditSheet(
      BuildContext context, WidgetRef ref, Collection collection) async {
    final result = await showModalBottomSheet<EditCollectionResult>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => EditCollectionSheet(collection: collection),
    );

    if (result == null) return;

    await ref.read(collectionRepositoryProvider).updateCollection(
          collection.copyWith(
            name: result.name,
            icon: result.icon,
            color: result.colorKey,
          ),
        );
    ref.read(syncTriggerProvider.notifier).notifyDataChanged();
    ref.invalidate(collectionByIdProvider(collectionId));
  }

  Future<void> _confirmDeleteCollection(
      BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la collection'),
        content: const Text(
          'Cette action supprimera la collection et tous ses éléments. Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await ref.read(collectionRepositoryProvider).deleteCollection(collectionId);
    ref.read(syncTriggerProvider.notifier).notifyDataChanged();
    if (context.mounted) context.go('/');
  }

  Widget _buildNoResultsState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.searchX, size: 48, color: context.appTextTertiary),
          const SizedBox(height: 12),
          Text(
            'Aucun résultat pour ces filtres',
            style: TextStyle(
              fontSize: 15,
              color: context.appTextSecondary,
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => ref
                .read(collectionFiltersProvider(collectionId).notifier)
                .state = {},
            icon: const Icon(LucideIcons.x, size: 16),
            label: const Text('Effacer les filtres'),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Supprimer'),
            content: const Text('Voulez-vous supprimer cet élément ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: TextButton.styleFrom(foregroundColor: AppColors.red),
                child: const Text('Supprimer'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
