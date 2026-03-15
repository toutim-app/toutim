import 'package:flutter/material.dart';

import '../../../../data/models/field_definition.dart';

/// Read-only display for tags fields as a wrap of colored chips.
class TagsDisplayRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;
  final Color collectionColor;

  const TagsDisplayRenderer({
    super.key,
    required this.definition,
    required this.value,
    required this.collectionColor,
  });

  List<String> get _tags {
    if (value is List) return (value as List).cast<String>();
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final tags = _tags;
    if (tags.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          definition.name,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: collectionColor.withValues(alpha: 0.7),
              ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: tags.map((tag) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: collectionColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                tag,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: collectionColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
