import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/field_definition.dart';

/// Read-only display for multiline text fields.
class TextAreaDisplayRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;

  const TextAreaDisplayRenderer({
    super.key,
    required this.definition,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          definition.name,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
          ),
        ),
      ],
    );
  }
}
