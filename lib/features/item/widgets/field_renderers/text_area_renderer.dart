import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/field_definition.dart';

/// Renderer for textArea field type.
class TextAreaRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  const TextAreaRenderer({
    super.key,
    required this.definition,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value as String? ?? '',
      maxLines: 5,
      minLines: 3,
      decoration: InputDecoration(
        labelText: definition.name,
        labelStyle: TextStyle(color: AppColors.textSecondary),
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
      ),
      onChanged: (text) => onChanged(text.isEmpty ? null : text),
    );
  }
}
