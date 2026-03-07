import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/field_definition.dart';
import '../../../data/providers/repository_providers.dart';
import '../../collection/providers/collection_providers.dart';
import '../providers/item_providers.dart';
import '../widgets/field_renderers/field_renderer_factory.dart';

/// Screen for creating or editing an item in a collection.
class ItemFormScreen extends ConsumerStatefulWidget {
  final String collectionId;
  final String? itemId;

  const ItemFormScreen({
    super.key,
    required this.collectionId,
    this.itemId,
  });

  bool get isEditing => itemId != null;

  @override
  ConsumerState<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends ConsumerState<ItemFormScreen> {
  final Map<String, dynamic> _values = {};
  bool _initialized = false;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final fieldsAsync =
        ref.watch(fieldDefinitionsStreamProvider(widget.collectionId));

    // Load existing values when editing
    if (widget.isEditing && !_initialized) {
      final itemAsync =
          ref.watch(itemWithFieldsStreamProvider(widget.itemId!));
      itemAsync.whenData((itemWithFields) {
        if (itemWithFields != null && !_initialized) {
          setState(() {
            for (final entry in itemWithFields.fieldValues.entries) {
              _values[entry.key] = entry.value.value;
            }
            _initialized = true;
          });
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Modifier' : 'Nouvel objet'),
        actions: [
          if (widget.isEditing)
            IconButton(
              icon: Icon(LucideIcons.trash2, color: AppColors.red),
              onPressed: _saving ? null : _delete,
            ),
          fieldsAsync.when(
            data: (fields) => TextButton.icon(
              onPressed: _saving ? null : () => _save(fields),
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(LucideIcons.check),
              label: const Text('Enregistrer'),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: fieldsAsync.when(
        data: (fields) {
          final sorted = [...fields]
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
          return _buildForm(sorted);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Erreur de chargement',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(List<FieldDefinition> fields) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: fields.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final field = fields[index];
        return buildFieldRenderer(
          definition: field,
          value: _values[field.id],
          onChanged: (newValue) {
            setState(() {
              _values[field.id] = newValue;
            });
          },
        );
      },
    );
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
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
    );

    if (confirmed != true || !mounted) return;

    await ref.read(itemRepositoryProvider).deleteItem(widget.itemId!);
    if (mounted) context.pop();
  }

  Future<void> _save(List<FieldDefinition> fields) async {
    // Validate required fields
    for (final field in fields) {
      if (field.isRequired && (_values[field.id] == null || _values[field.id].toString().isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Le champ "${field.name}" est obligatoire'),
            backgroundColor: AppColors.red,
          ),
        );
        return;
      }
    }

    setState(() => _saving = true);

    try {
      final repo = ref.read(itemRepositoryProvider);

      // Filter out null values
      final nonNullValues = Map<String, dynamic>.fromEntries(
        _values.entries.where((e) => e.value != null),
      );

      if (widget.isEditing) {
        await repo.updateItem(
          itemId: widget.itemId!,
          fieldValues: nonNullValues,
        );
      } else {
        await repo.createItem(
          collectionId: widget.collectionId,
          fieldValues: nonNullValues,
        );
      }

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erreur lors de la sauvegarde'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }
}
