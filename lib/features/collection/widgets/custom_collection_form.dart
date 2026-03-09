import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/extensions/color_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/color_picker_row.dart';
import '../../settings/providers/auto_sync_providers.dart';
import '../providers/create_collection_provider.dart';

/// Form for creating a custom collection (name + color).
class CustomCollectionForm extends ConsumerStatefulWidget {
  final VoidCallback onCreated;

  const CustomCollectionForm({super.key, required this.onCreated});

  @override
  ConsumerState<CustomCollectionForm> createState() =>
      _CustomCollectionFormState();
}

class _CustomCollectionFormState extends ConsumerState<CustomCollectionForm> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedColor = 'blue';
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isCreating = true);

    try {
      final service = ref.read(collectionCreationServiceProvider);
      await service.createCustom(
        name: name,
        colorKey: _selectedColor,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );
      ref.read(syncTriggerProvider.notifier).notifyDataChanged();
      widget.onCreated();
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Nouvelle collection',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: context.appTextPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _nameController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nom de la collection',
            hintText: 'Ex : Mes livres, Recettes...',
            prefixIcon: Icon(LucideIcons.type),
          ),
          textCapitalization: TextCapitalization.sentences,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description (optionnel)',
            hintText: 'Une courte description...',
            prefixIcon: Icon(LucideIcons.alignLeft),
          ),
          textCapitalization: TextCapitalization.sentences,
          maxLines: 2,
        ),
        const SizedBox(height: 24),
        Text(
          'Couleur',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: context.appTextSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        ColorPickerRow(
          selectedColorKey: _selectedColor,
          onColorSelected: (key) => setState(() => _selectedColor = key),
        ),
        const SizedBox(height: 32),
        FilledButton.icon(
          onPressed:
              _nameController.text.trim().isEmpty || _isCreating
                  ? null
                  : _handleCreate,
          icon: _isCreating
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(LucideIcons.plus),
          label: Text(_isCreating ? 'Création...' : 'Créer la collection'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            backgroundColor:
                AppColors.templateColors[_selectedColor] ?? AppColors.blue,
          ),
        ),
      ],
    );
  }
}
