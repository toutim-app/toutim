import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/extensions/color_extensions.dart';

/// Empty state shown when a collection has no items.
class CollectionEmptyState extends StatelessWidget {
  const CollectionEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.packageOpen,
            size: 64,
            color: context.appTextTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun élément',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: context.appTextSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Appuyez sur + pour ajouter un élément',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.appTextTertiary,
                ),
          ),
        ],
      ),
    );
  }
}
