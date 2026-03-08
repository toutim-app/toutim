import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/field_definition.dart';

/// Read-only display for text fields.
class TextDisplayRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;

  const TextDisplayRenderer({
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
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textPrimary,
              ),
        ),
      ],
    );
  }
}
