import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/field_definition.dart';

/// Read-only display for rating fields (non-interactive stars).
class RatingDisplayRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;

  const RatingDisplayRenderer({
    super.key,
    required this.definition,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final rating = (value as int?) ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          definition.name,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.appTextSecondary,
              ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(5, (index) {
              final isFilled = (index + 1) <= rating;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  LucideIcons.star,
                  color: isFilled ? AppColors.yellow : context.appBorder,
                  size: 24,
                ),
              );
            }),
            const SizedBox(width: 8),
            Text(
              '$rating/5',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.appTextSecondary,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
