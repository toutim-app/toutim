import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/sync_change.dart';
import '../../../data/providers/repository_providers.dart';

part 'settings_providers.g.dart';

/// Auth state for the settings screen.
enum AuthState { notConfigured, loggedOut, loggedIn }

/// Provides the current auth state.
@riverpod
Future<AuthState> authState(AuthStateRef ref) async {
  final syncRepo = await ref.watch(syncRepositoryProvider.future);
  if (!syncRepo.isConfigured) return AuthState.notConfigured;
  final authenticated = await syncRepo.isAuthenticated;
  return authenticated ? AuthState.loggedIn : AuthState.loggedOut;
}

/// Provides the current server URL.
@riverpod
Future<String?> serverUrl(ServerUrlRef ref) async {
  final syncRepo = await ref.watch(syncRepositoryProvider.future);
  return syncRepo.serverUrl;
}

/// Provides the authenticated user's email.
@riverpod
Future<String?> userEmailSetting(UserEmailSettingRef ref) async {
  final syncRepo = await ref.watch(syncRepositoryProvider.future);
  return syncRepo.userEmail;
}

/// Notifier for sync actions (trigger sync, track state).
@riverpod
class SyncAction extends _$SyncAction {
  @override
  AsyncValue<SyncResult?> build() => const AsyncData(null);

  Future<void> sync() async {
    state = const AsyncLoading();
    try {
      final syncRepo = await ref.read(syncRepositoryProvider.future);
      final result = await syncRepo.sync();
      state = AsyncData(result);
      // Refresh auth state after sync.
      ref.invalidate(authStateProvider);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
