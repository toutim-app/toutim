import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../providers/settings_providers.dart';
import '../widgets/auth_section.dart';
import '../widgets/auto_sync_section.dart';
import '../widgets/server_config_section.dart';

/// Settings screen with server configuration, account, and sync.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Paramètres',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ServerConfigSection(),
          const SizedBox(height: 12),
          const AuthSection(),
          const SizedBox(height: 12),
          _SyncSection(),
          const SizedBox(height: 12),
          const AutoSyncSection(),
        ],
      ),
    );
  }
}

class _SyncSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);
    final syncAction = ref.watch(syncActionProvider);

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
                    color: AppColors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.refreshCw,
                      color: AppColors.green, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Synchronisation',
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
                final isSyncing = syncAction is AsyncLoading;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!isLoggedIn)
                      Text(
                        'Connectez-vous pour synchroniser vos données.',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                      ),
                    if (isLoggedIn) ...[
                      // Sync result display.
                      if (syncAction is AsyncData &&
                          syncAction.value != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.checkCircle,
                                  size: 16, color: AppColors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${syncAction.value!.pushed} envoyé(s), '
                                  '${syncAction.value!.pulled} reçu(s)',
                                  style: const TextStyle(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      // Sync error display.
                      if (syncAction is AsyncError) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.alertCircle,
                                  size: 16, color: AppColors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${syncAction.error}',
                                  style: const TextStyle(
                                    color: AppColors.red,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      FilledButton.icon(
                        onPressed: isSyncing
                            ? null
                            : () => ref
                                .read(syncActionProvider.notifier)
                                .sync(),
                        icon: isSyncing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(LucideIcons.refreshCw, size: 18),
                        label: Text(isSyncing
                            ? 'Synchronisation...'
                            : 'Synchroniser maintenant'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
