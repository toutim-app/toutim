import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/field_definition.dart';

/// Renderer for text and barcode field types.
class TextFieldRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  const TextFieldRenderer({
    super.key,
    required this.definition,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value as String? ?? '',
      decoration: InputDecoration(
        labelText: definition.name,
        labelStyle: TextStyle(color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        suffixIcon: definition.type.name == 'barcode'
            ? Icon(LucideIcons.scanLine, color: AppColors.textTertiary)
            : null,
      ),
      onChanged: (text) => onChanged(text.isEmpty ? null : text),
    );
  }
}
