import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/extensions/collection_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/repository_providers.dart';
import '../providers/collection_providers.dart';
import '../widgets/collection_empty_state.dart';
import '../widgets/item_card.dart';

/// Screen displaying the contents of a single collection.
class CollectionDetailScreen extends ConsumerWidget {
  final String collectionId;

  const CollectionDetailScreen({super.key, required this.collectionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionAsync = ref.watch(collectionByIdProvider(collectionId));
    final fieldsAsync = ref.watch(fieldDefinitionsStreamProvider(collectionId));
    final itemsAsync = ref.watch(itemsStreamProvider(collectionId));

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
          IconButton(
            icon: Icon(LucideIcons.trash2, color: AppColors.red),
            onPressed: () => _confirmDeleteCollection(context, ref),
          ),
        ],
      ),
      body: itemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const CollectionEmptyState();
          }
          return fieldsAsync.when(
            data: (fields) => ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return Dismissible(
                  key: ValueKey(item.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) => _confirmDelete(context),
                  onDismissed: (_) {
                    ref.read(itemRepositoryProvider).deleteItem(item.id);
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
                    itemId: item.id,
                    fieldDefinitions: fields,
                    onTap: () => context.push(
                      '/collection/$collectionId/item/${item.id}',
                    ),
                  ),
                );
              },
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
                  color: AppColors.textSecondary,
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

  Future<void> _confirmDeleteCollection(
      BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la collection'),
        content: const Text(
          'Cette action supprimera la collection et tous ses objets. Cette action est irréversible.',
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
    if (context.mounted) context.go('/');
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Supprimer'),
            content: const Text('Voulez-vous supprimer cet objet ?'),
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
