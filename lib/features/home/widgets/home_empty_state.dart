import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/extensions/color_extensions.dart';

/// Empty state shown when the user has no collections yet.
class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.layoutGrid,
              size: 64,
              color: context.appTextTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune collection',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Appuyez sur + pour créer votre première collection',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.appTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
