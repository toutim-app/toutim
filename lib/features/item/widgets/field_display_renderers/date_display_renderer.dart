import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../data/models/enums/field_type.dart';
import '../../../../data/models/field_definition.dart';

/// Read-only display for date and dateTime fields.
class DateDisplayRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;
  final Color collectionColor;

  const DateDisplayRenderer({
    super.key,
    required this.definition,
    required this.value,
    required this.collectionColor,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = value.toString();
    final date = DateTime.tryParse(dateStr);
    if (date == null) return const SizedBox.shrink();

    final formatted = definition.type == FieldType.dateTime
        ? '${DateFormat.yMMMMd('fr_FR').format(date)} à ${DateFormat.Hm().format(date)}'
        : DateFormat.yMMMMd('fr_FR').format(date);

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
          children: [
            Icon(LucideIcons.calendar, size: 18, color: collectionColor),
            const SizedBox(width: 8),
            Text(
              formatted,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: context.appTextPrimary,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
