import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/field_definition.dart';

/// Fallback renderer for unsupported field types.
class UnsupportedFieldRenderer extends StatelessWidget {
  final FieldDefinition definition;

  const UnsupportedFieldRenderer({
    super.key,
    required this.definition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: context.appSurfaceAlt,
        border: Border.all(color: context.appBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.info, color: context.appTextTertiary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${definition.name} — type "${definition.type.name}" non supporté',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.appTextTertiary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
