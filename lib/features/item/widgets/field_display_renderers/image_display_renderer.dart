import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../data/models/field_definition.dart';

/// Read-only display for image fields (large image).
class ImageDisplayRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;

  const ImageDisplayRenderer({
    super.key,
    required this.definition,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = value as String?;
    if (imagePath == null || imagePath.isEmpty) return const SizedBox.shrink();

    final file = File(imagePath);
    if (!file.existsSync()) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          definition.name,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.appTextSecondary,
              ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            file,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
