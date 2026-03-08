import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/field_definition.dart';

/// Read-only display for boolean fields as a chip.
class BooleanDisplayRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;
  final Color collectionColor;

  const BooleanDisplayRenderer({
    super.key,
    required this.definition,
    required this.value,
    required this.collectionColor,
  });

  @override
  Widget build(BuildContext context) {
    final isTrue = value == true;
    final chipColor = isTrue ? AppColors.green : AppColors.textTertiary;

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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: chipColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isTrue ? LucideIcons.check : LucideIcons.x,
                size: 16,
                color: chipColor,
              ),
              const SizedBox(width: 6),
              Text(
                isTrue ? 'Oui' : 'Non',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: chipColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
