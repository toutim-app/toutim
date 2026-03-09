import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/extensions/color_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/auto_sync_providers.dart';
import '../providers/settings_providers.dart';

/// Section des paramètres pour la synchronisation automatique.
class AutoSyncSection extends ConsumerWidget {
  const AutoSyncSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);
    final enabledAsync = ref.watch(autoSyncEnabledProvider);
    final intervalAsync = ref.watch(autoSyncIntervalProvider);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.timer,
                      color: AppColors.teal, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Synchronisation automatique',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            authAsync.when(
              data: (state) {
                final isLoggedIn = state == AuthState.loggedIn;

                if (!isLoggedIn) {
                  return Text(
                    'Connectez-vous pour activer la synchronisation automatique.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: context.appTextSecondary,
                        ),
                  );
                }

                final enabled = enabledAsync.valueOrNull ?? false;
                final interval =
                    intervalAsync.valueOrNull ?? SyncInterval.fiveMinutes;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Activer la sync automatique',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                      subtitle: Text(
                        enabled
                            ? 'Toutes les ${interval.label}'
                            : 'Synchronisation manuelle uniquement',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: context.appTextTertiary,
                                ),
                      ),
                      value: enabled,
                      activeThumbColor: AppColors.teal,
                      onChanged: (value) {
                        ref
                            .read(autoSyncEnabledProvider.notifier)
                            .setEnabled(value);
                      },
                    ),
                    if (enabled) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Intervalle',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: context.appTextSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<SyncInterval>(
                          segments: SyncInterval.values
                              .map((i) => ButtonSegment(
                                    value: i,
                                    label: Text(i.label),
                                  ))
                              .toList(),
                          selected: {interval},
                          onSelectionChanged: (selected) {
                            ref
                                .read(autoSyncIntervalProvider.notifier)
                                .setInterval(selected.first);
                          },
                          style: SegmentedButton.styleFrom(
                            selectedBackgroundColor:
                                AppColors.teal.withValues(alpha: 0.15),
                            selectedForegroundColor: AppColors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Erreur: $e'),
            ),
          ],
        ),
      ),
    );
  }
}
