import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/field_definition.dart';

/// Renderer for boolean field type.
class BooleanFieldRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  const BooleanFieldRenderer({
    super.key,
    required this.definition,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final boolValue = value as bool? ?? false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            definition.name,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          Switch.adaptive(
            value: boolValue,
            activeTrackColor: AppColors.blue,
            onChanged: (newValue) => onChanged(newValue),
          ),
        ],
      ),
    );
  }
}
