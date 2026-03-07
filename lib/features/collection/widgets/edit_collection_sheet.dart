import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/collection.dart';
import '../../../shared/widgets/color_picker_row.dart';

/// Result returned by [EditCollectionSheet].
class EditCollectionResult {
  final String name;
  final String? icon;
  final String colorKey;

  const EditCollectionResult({
    required this.name,
    this.icon,
    required this.colorKey,
  });
}

/// Bottom sheet for editing a collection's name, emoji and color.
class EditCollectionSheet extends StatefulWidget {
  final Collection collection;

  const EditCollectionSheet({super.key, required this.collection});

  @override
  State<EditCollectionSheet> createState() => _EditCollectionSheetState();
}

class _EditCollectionSheetState extends State<EditCollectionSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _emojiController;
  late String _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.collection.name);
    _emojiController =
        TextEditingController(text: widget.collection.icon ?? '');
    _selectedColor = widget.collection.color;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    Navigator.pop(
      context,
      EditCollectionResult(
        name: name,
        icon: _emojiController.text.trim().isEmpty
            ? null
            : _emojiController.text.trim(),
        colorKey: _selectedColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Modifier la collection',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emojiController,
              decoration: InputDecoration(
                labelText: 'Emoji',
                hintText: 'Ex: 💪',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Couleur',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            ColorPickerRow(
              selectedColorKey: _selectedColor,
              onColorSelected: (key) {
                setState(() => _selectedColor = key);
              },
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
