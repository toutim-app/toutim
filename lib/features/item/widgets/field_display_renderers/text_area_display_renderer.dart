import 'package:flutter/material.dart';

import '../../../../core/extensions/color_extensions.dart';
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
                color: context.appTextSecondary,
              ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.appSurfaceAlt,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.appTextPrimary,
                  height: 1.5,
                ),
          ),
        ),
      ],
    );
  }
}
