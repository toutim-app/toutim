import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../data/models/enums/field_type.dart';
import '../../../../data/models/field_definition.dart';

/// Read-only display for number, decimal, and currency fields.
class NumberDisplayRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;

  const NumberDisplayRenderer({
    super.key,
    required this.definition,
    required this.value,
  });

  String _formatValue() {
    final num = value;
    return switch (definition.type) {
      FieldType.currency => NumberFormat.currency(
          locale: 'fr_FR',
          symbol: '€',
        ).format(num is double ? num : double.tryParse(num.toString()) ?? 0),
      FieldType.decimal => NumberFormat.decimalPattern('fr_FR')
          .format(num is double ? num : double.tryParse(num.toString()) ?? 0),
      _ => num.toString(),
    };
  }

  @override
  Widget build(BuildContext context) {
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
        Text(
          _formatValue(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: context.appTextPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
