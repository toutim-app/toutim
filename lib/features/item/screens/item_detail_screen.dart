import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/extensions/collection_extensions.dart';
import '../../../core/extensions/color_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/enums/field_type.dart';
import '../../../data/models/field_definition.dart';
import '../../../data/models/item_with_fields.dart';
import '../../../data/providers/repository_providers.dart';
import '../../collection/providers/collection_providers.dart';
import '../providers/item_providers.dart';
import '../widgets/field_display_renderers/field_display_renderer_factory.dart';

/// Read-only detail screen for viewing an item's field values.
class ItemDetailScreen extends ConsumerWidget {
  final String collectionId;
  final String itemId;

  const ItemDetailScreen({
    super.key,
    required this.collectionId,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionAsync = ref.watch(collectionByIdProvider(collectionId));
    final fieldsAsync =
        ref.watch(fieldDefinitionsStreamProvider(collectionId));
    final itemAsync = ref.watch(itemWithFieldsStreamProvider(itemId));

    final collectionColor = collectionAsync.when(
      data: (c) => c?.resolvedColor ?? AppColors.blue,
      loading: () => AppColors.blue,
      error: (_, _) => AppColors.blue,
    );

    return Scaffold(
      appBar: AppBar(
        title: itemAsync.when(
          data: (itemWithFields) {
            if (itemWithFields == null) return const Text('Détail');
            return fieldsAsync.when(
              data: (fields) => Text(_resolveTitle(fields, itemWithFields)),
              loading: () => const Text('...'),
              error: (_, _) => const Text('Détail'),
            );
          },
          loading: () => const Text('...'),
          error: (_, _) => const Text('Détail'),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(LucideIcons.moreVertical,
                color: context.appTextSecondary, size: 20),
            onSelected: (value) {
              if (value == 'edit') {
                context.push(
                    '/collection/$collectionId/item/$itemId/edit');
              } else if (value == 'delete') {
                _confirmDelete(context, ref);
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
                    const Text('Modifier'),
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
      body: fieldsAsync.when(
        data: (fields) => itemAsync.when(
          data: (itemWithFields) {
            if (itemWithFields == null) {
              return Center(
                child: Text(
                  'Élément introuvable',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.appTextSecondary,
                      ),
                ),
              );
            }
            return _buildContent(
                context, ref, fields, itemWithFields, collectionColor);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(
            child: Text(
              'Erreur de chargement',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.appTextSecondary,
                  ),
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Text(
            'Erreur de chargement',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.appTextSecondary,
                ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.push('/collection/$collectionId/item/$itemId/edit'),
        backgroundColor: collectionColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(LucideIcons.pencil, color: Colors.white),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<FieldDefinition> fields,
    ItemWithFields itemWithFields,
    Color collectionColor,
  ) {
    final sorted = [...fields]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    // Separate image fields (shown first, larger) from others
    final imageFields = sorted
        .where((f) =>
            f.type == FieldType.image &&
            _hasValue(itemWithFields, f.id))
        .toList();
    // Include tracker fields even without value (so user can add first entry)
    final otherFields = sorted
        .where((f) =>
            f.type != FieldType.image &&
            (_hasValue(itemWithFields, f.id) || f.type == FieldType.tracker))
        .toList();

    return CustomScrollView(
      slivers: [
        // Hero images
        if (imageFields.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: imageFields
                    .map((f) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: buildFieldDisplayRenderer(
                            definition: f,
                            value: itemWithFields.fieldValues[f.id]!.value,
                            collectionColor: collectionColor,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        // Other fields
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList.separated(
            itemCount: otherFields.length,
            separatorBuilder: (_, _) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final field = otherFields[index];
              final value = itemWithFields.fieldValues[field.id]?.value;
              return buildFieldDisplayRenderer(
                definition: field,
                value: value,
                collectionColor: collectionColor,
                onChanged: field.type == FieldType.tracker
                    ? (newValue) => _updateField(ref, field.id, newValue)
                    : null,
              );
            },
          ),
        ),
        // Metadata footer
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            child: Text(
              'Créé le ${DateFormat.yMMMMd('fr_FR').format(itemWithFields.item.createdAt)}'
              ' · Modifié le ${DateFormat.yMMMMd('fr_FR').format(itemWithFields.item.updatedAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.appTextTertiary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _updateField(
      WidgetRef ref, String fieldDefinitionId, dynamic newValue) async {
    final repo = ref.read(itemRepositoryProvider);
    await repo.updateItem(
      itemId: itemId,
      fieldValues: {fieldDefinitionId: newValue},
    );
  }

  String _resolveTitle(
      List<FieldDefinition> fields, ItemWithFields itemWithFields) {
    final sorted = [...fields]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    final titleField = sorted.firstWhere(
      (f) => f.isRequired,
      orElse: () => sorted.first,
    );
    final titleValue = itemWithFields.fieldValues[titleField.id]?.value;
    if (titleValue == null) return 'Sans titre';
    final str = titleValue.toString();
    return str.isEmpty ? 'Sans titre' : str;
  }

  bool _hasValue(ItemWithFields itemWithFields, String fieldId) {
    final fv = itemWithFields.fieldValues[fieldId];
    if (fv == null || fv.value == null) return false;
    if (fv.value is String && (fv.value as String).isEmpty) return false;
    return true;
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
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
    );

    if (confirmed != true || !context.mounted) return;

    await ref.read(itemRepositoryProvider).deleteItem(itemId);
    if (context.mounted) context.pop();
  }
}
