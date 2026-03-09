import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../data/models/field_definition.dart';

/// Renderer for date field type.
class DateFieldRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  const DateFieldRenderer({
    super.key,
    required this.definition,
    this.value,
    required this.onChanged,
  });

  DateTime? _parseDate() {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  @override
  Widget build(BuildContext context) {
    final date = _parseDate();
    final displayText = date != null
        ? DateFormat.yMMMMd('fr_FR').format(date)
        : '';

    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onChanged(picked.toIso8601String().split('T').first);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: definition.name,
          labelStyle: TextStyle(color: context.appTextSecondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: context.appBorder),
          ),
          suffixIcon: Icon(
            LucideIcons.calendar,
            color: context.appTextTertiary,
          ),
        ),
        child: Text(
          displayText,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: date != null
                    ? context.appTextPrimary
                    : context.appTextTertiary,
              ),
        ),
      ),
    );
  }
}
