import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/remote/api_client.dart';
import '../../../data/providers/repository_providers.dart';
import '../providers/settings_providers.dart';

/// Section for authentication (login/register) and account management.
class AuthSection extends ConsumerStatefulWidget {
  const AuthSection({super.key});

  @override
  ConsumerState<AuthSection> createState() => _AuthSectionState();
}

class _AuthSectionState extends ConsumerState<AuthSection> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _isRegisterMode = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Email et mot de passe requis');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final syncRepo = await ref.read(syncRepositoryProvider.future);
      if (_isRegisterMode) {
        await syncRepo.register(email, password);
      } else {
        await syncRepo.login(email, password);
      }
      ref.invalidate(authStateProvider);
      ref.invalidate(userEmailSettingProvider);
      if (mounted) {
        _emailController.clear();
        _passwordController.clear();
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    setState(() => _loading = true);
    try {
      final syncRepo = await ref.read(syncRepositoryProvider.future);
      await syncRepo.logout();
      ref.invalidate(authStateProvider);
      ref.invalidate(userEmailSettingProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le compte'),
        content: const Text(
          'Cette action est irréversible. Toutes vos données sur le serveur seront supprimées. '
          'Vos données locales resteront sur cet appareil.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _loading = true);
    try {
      final syncRepo = await ref.read(syncRepositoryProvider.future);
      await syncRepo.deleteAccount();
      ref.invalidate(authStateProvider);
      ref.invalidate(userEmailSettingProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authStateProvider);

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
                    color: AppColors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.user, color: AppColors.purple, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Compte',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            authAsync.when(
              data: (state) {
                if (state == AuthState.notConfigured) {
                  return Text(
                    'Configurez l\'URL du serveur pour accéder à votre compte.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  );
                }
                if (state == AuthState.loggedIn) {
                  return _buildLoggedInView();
                }
                return _buildAuthForm();
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

  Widget _buildLoggedInView() {
    final emailAsync = ref.watch(userEmailSettingProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.checkCircle,
                size: 16, color: AppColors.green),
            const SizedBox(width: 8),
            Text(
              'Connecté',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.green,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        emailAsync.when(
          data: (email) => Text(
            email ?? '',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _loading ? null : _logout,
                icon: const Icon(LucideIcons.logOut, size: 18),
                label: const Text('Déconnexion'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: _loading ? null : _deleteAccount,
              icon: const Icon(LucideIcons.trash2, size: 18),
              label: const Text('Supprimer'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.red,
                side: const BorderSide(color: AppColors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAuthForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(LucideIcons.mail),
          ),
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          textCapitalization: TextCapitalization.none,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(LucideIcons.lock),
          ),
          obscureText: true,
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(
            _error!,
            style: const TextStyle(color: AppColors.red, fontSize: 13),
          ),
        ],
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _loading ? null : _submit,
          icon: _loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Icon(
                  _isRegisterMode ? LucideIcons.userPlus : LucideIcons.logIn,
                  size: 18,
                ),
          label: Text(_isRegisterMode ? 'Créer un compte' : 'Se connecter'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () =>
              setState(() => _isRegisterMode = !_isRegisterMode),
          child: Text(
            _isRegisterMode
                ? 'Déjà un compte ? Se connecter'
                : 'Pas de compte ? Créer un compte',
            style: const TextStyle(color: AppColors.blue),
          ),
        ),
      ],
    );
  }
}
