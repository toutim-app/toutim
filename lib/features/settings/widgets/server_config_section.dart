import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/providers/repository_providers.dart';
import '../providers/settings_providers.dart';

/// Section for configuring the server URL and testing the connection.
class ServerConfigSection extends ConsumerStatefulWidget {
  const ServerConfigSection({super.key});

  @override
  ConsumerState<ServerConfigSection> createState() =>
      _ServerConfigSectionState();
}

class _ServerConfigSectionState extends ConsumerState<ServerConfigSection> {
  final _urlController = TextEditingController();
  bool _testing = false;
  String? _testResult;

  @override
  void initState() {
    super.initState();
    _loadUrl();
  }

  Future<void> _loadUrl() async {
    final url = await ref.read(serverUrlProvider.future);
    if (mounted) {
      _urlController.text = url;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _saveUrl() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;
    final syncRepo = await ref.read(syncRepositoryProvider.future);
    await syncRepo.setServerUrl(url);
    ref.invalidate(serverUrlProvider);
    ref.invalidate(authStateProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL du serveur enregistrée')),
      );
    }
  }

  Future<void> _testConnection() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    setState(() {
      _testing = true;
      _testResult = null;
    });

    // Save URL first so ApiClient uses it.
    final syncRepo = await ref.read(syncRepositoryProvider.future);
    await syncRepo.setServerUrl(url);
    ref.invalidate(serverUrlProvider);

    final success = await syncRepo.testConnection();

    if (mounted) {
      setState(() {
        _testing = false;
        _testResult = success ? 'Connexion réussie' : 'Connexion échouée';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    color: AppColors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.server, color: AppColors.blue, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Serveur',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'URL du serveur',
                hintText: 'https://api.toutim.app',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(LucideIcons.globe),
              ),
              keyboardType: TextInputType.url,
              autocorrect: false,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _testing ? null : _testConnection,
                    icon: _testing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(LucideIcons.wifi, size: 18),
                    label: const Text('Tester'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _saveUrl,
                    icon: const Icon(LucideIcons.save, size: 18),
                    label: const Text('Enregistrer'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_testResult != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    _testResult == 'Connexion réussie'
                        ? LucideIcons.checkCircle
                        : LucideIcons.xCircle,
                    size: 16,
                    color: _testResult == 'Connexion réussie'
                        ? AppColors.green
                        : AppColors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _testResult!,
                    style: TextStyle(
                      color: _testResult == 'Connexion réussie'
                          ? AppColors.green
                          : AppColors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
