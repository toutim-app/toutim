import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/enums/field_type.dart';
import '../../../data/models/field_definition.dart';
import '../../../data/providers/repository_providers.dart';
import '../../collection/providers/collection_providers.dart';
import '../widgets/field_form_sheet.dart';

/// Screen for managing (add, edit, reorder, delete) field definitions
/// of a collection.
class FieldEditorScreen extends ConsumerWidget {
  final String collectionId;

  const FieldEditorScreen({super.key, required this.collectionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fieldsAsync = ref.watch(fieldDefinitionsStreamProvider(collectionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gérer les champs'),
      ),
      body: fieldsAsync.when(
        data: (fields) => fields.isEmpty
            ? _buildEmptyState(context)
            : _buildFieldList(context, ref, fields),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const SizedBox.shrink(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context, ref, fieldsAsync.valueOrNull),
        backgroundColor: AppColors.blue,
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.layoutList,
              size: 48, color: AppColors.textTertiary),
          const SizedBox(height: 12),
          Text(
            'Aucun champ défini',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textTertiary,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Appuyez sur + pour ajouter un champ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldList(
      BuildContext context, WidgetRef ref, List<FieldDefinition> fields) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      itemCount: fields.length,
      onReorder: (oldIndex, newIndex) =>
          _onReorder(ref, fields, oldIndex, newIndex),
      proxyDecorator: (child, index, animation) {
        return Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(12),
          child: child,
        );
      },
      itemBuilder: (context, index) {
        final field = fields[index];
        return _FieldTile(
          key: ValueKey(field.id),
          field: field,
          onTap: () => _showEditSheet(context, ref, field),
          onDelete: () => _confirmDelete(context, ref, field),
        );
      },
    );
  }

  void _onReorder(
      WidgetRef ref, List<FieldDefinition> fields, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final reordered = [...fields];
    final item = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, item);

    final updated = <FieldDefinition>[];
    for (var i = 0; i < reordered.length; i++) {
      updated.add(reordered[i].copyWith(sortOrder: i));
    }
    ref.read(collectionRepositoryProvider).reorderFieldDefinitions(updated);
  }

  Future<void> _showAddSheet(
      BuildContext context, WidgetRef ref, List<FieldDefinition>? fields) async {
    final result = await showModalBottomSheet<FieldFormResult>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const FieldFormSheet(),
    );

    if (result == null) return;

    final nextOrder = (fields?.length ?? 0);
    await ref.read(collectionRepositoryProvider).addFieldDefinition(
          collectionId: collectionId,
          name: result.name,
          type: result.type,
          sortOrder: nextOrder,
          isRequired: result.isRequired,
          showInCard: result.showInCard,
          searchable: result.searchable,
          sortable: result.sortable,
          options: result.options,
        );
  }

  Future<void> _showEditSheet(
      BuildContext context, WidgetRef ref, FieldDefinition field) async {
    final result = await showModalBottomSheet<FieldFormResult>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => FieldFormSheet(definition: field),
    );

    if (result == null) return;

    await ref.read(collectionRepositoryProvider).updateFieldDefinition(
          field.copyWith(
            name: result.name,
            isRequired: result.isRequired,
            showInCard: result.showInCard,
            searchable: result.searchable,
            sortable: result.sortable,
            options: result.options,
          ),
        );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, FieldDefinition field) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer le champ'),
        content: Text(
          'Le champ "${field.name}" et toutes ses valeurs seront supprimés. '
          'Cette action est irréversible.',
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

    if (confirmed != true) return;
    await ref.read(collectionRepositoryProvider).deleteFieldDefinition(field.id);
  }
}

/// A single field tile in the editor list.
class _FieldTile extends StatelessWidget {
  final FieldDefinition field;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _FieldTile({
    super.key,
    required this.field,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Icon(_iconForType(field.type),
                    size: 16, color: AppColors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      field.name,
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                    Text(
                      _labelForType(field.type),
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textTertiary,
                              ),
                    ),
                  ],
                ),
              ),
              if (field.isRequired)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Requis',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              GestureDetector(
                onTap: onDelete,
                child: Icon(LucideIcons.trash2,
                    size: 16, color: AppColors.textTertiary),
              ),
              const SizedBox(width: 8),
              ReorderableDragStartListener(
                index: 0, // Overridden by ReorderableListView
                child: Icon(LucideIcons.gripVertical,
                    size: 18, color: AppColors.textTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForType(FieldType type) {
    return switch (type) {
      FieldType.text => LucideIcons.type,
      FieldType.textArea => LucideIcons.alignLeft,
      FieldType.number => LucideIcons.hash,
      FieldType.decimal => LucideIcons.hash,
      FieldType.currency => LucideIcons.banknote,
      FieldType.boolean => LucideIcons.toggleLeft,
      FieldType.date || FieldType.dateTime => LucideIcons.calendar,
      FieldType.select => LucideIcons.list,
      FieldType.rating => LucideIcons.star,
      FieldType.image => LucideIcons.image,
      FieldType.barcode => LucideIcons.scanLine,
      FieldType.tracker => LucideIcons.lineChart,
      _ => LucideIcons.circle,
    };
  }

  String _labelForType(FieldType type) {
    return switch (type) {
      FieldType.text => 'Texte',
      FieldType.textArea => 'Texte long',
      FieldType.number => 'Nombre',
      FieldType.decimal => 'Décimal',
      FieldType.currency => 'Monétaire',
      FieldType.boolean => 'Oui / Non',
      FieldType.date => 'Date',
      FieldType.dateTime => 'Date et heure',
      FieldType.select => 'Liste de choix',
      FieldType.rating => 'Note',
      FieldType.image => 'Image',
      FieldType.barcode => 'Code-barres',
      FieldType.tracker => 'Suivi',
      _ => type.name,
    };
  }
}
