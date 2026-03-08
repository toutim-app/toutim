import 'package:flutter/material.dart';

import '../../../../data/models/field_definition.dart';

/// Read-only display for select fields as a styled chip.
class SelectDisplayRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;
  final Color collectionColor;

  const SelectDisplayRenderer({
    super.key,
    required this.definition,
    required this.value,
    required this.collectionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          definition.name,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: collectionColor.withValues(alpha: 0.7),
              ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: collectionColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: collectionColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}
