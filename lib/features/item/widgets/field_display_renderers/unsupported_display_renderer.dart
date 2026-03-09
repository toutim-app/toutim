import 'package:flutter/material.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../data/models/field_definition.dart';

/// Fallback display for unsupported field types.
class UnsupportedDisplayRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;

  const UnsupportedDisplayRenderer({
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
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.appTextTertiary,
              ),
        ),
      ],
    );
  }
}
