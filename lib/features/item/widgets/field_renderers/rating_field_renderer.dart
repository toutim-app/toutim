import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/field_definition.dart';

/// Renderer for rating field type (1-5 stars).
class RatingFieldRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  const RatingFieldRenderer({
    super.key,
    required this.definition,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final rating = (value as int?) ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: context.appBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            definition.name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.appTextSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isFilled = starIndex <= rating;
              return GestureDetector(
                onTap: () => onChanged(starIndex == rating ? 0 : starIndex),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    isFilled ? LucideIcons.star : LucideIcons.star,
                    color: isFilled ? AppColors.yellow : context.appBorder,
                    size: 32,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
