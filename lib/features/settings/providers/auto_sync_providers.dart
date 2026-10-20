import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/providers/datasource_providers.dart';
import '../../../data/providers/repository_providers.dart';
import 'settings_providers.dart';

part 'auto_sync_providers.g.dart';

/// Intervalles de synchronisation automatique disponibles.
enum SyncInterval {
  oneMinute(1, '1 min'),
  fiveMinutes(5, '5 min'),
  fifteenMinutes(15, '15 min'),
  thirtyMinutes(30, '30 min');

  const SyncInterval(this.minutes, this.label);
  final int minutes;
  final String label;

  static SyncInterval fromMinutes(int minutes) {
    return SyncInterval.values.firstWhere(
      (e) => e.minutes == minutes,
      orElse: () => SyncInterval.fiveMinutes,
    );
  }
}

const _kAutoSyncEnabled = 'auto_sync_enabled';
const _kAutoSyncIntervalMinutes = 'auto_sync_interval_minutes';

/// Préférence : sync automatique activée ou non.
@Riverpod(keepAlive: true)
class AutoSyncEnabled extends _$AutoSyncEnabled {
  @override
  Future<bool> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return prefs.getBool(_kAutoSyncEnabled) ?? false;
  }

  Future<void> setEnabled(bool enabled) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setBool(_kAutoSyncEnabled, enabled);
    state = AsyncData(enabled);
  }
}

/// Préférence : intervalle de sync automatique.
@Riverpod(keepAlive: true)
class AutoSyncInterval extends _$AutoSyncInterval {
  @override
  Future<SyncInterval> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    final minutes = prefs.getInt(_kAutoSyncIntervalMinutes) ?? 5;
    return SyncInterval.fromMinutes(minutes);
  }

  Future<void> setInterval(SyncInterval interval) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setInt(_kAutoSyncIntervalMinutes, interval.minutes);
    state = AsyncData(interval);
  }
}

/// Compteur incrémenté à chaque modification locale.
/// Le SyncManager écoute ce provider pour déclencher une sync debounced.
@Riverpod(keepAlive: true)
class SyncTrigger extends _$SyncTrigger {
  @override
  int build() => 0;

  void notifyDataChanged() {
    state = state + 1;
  }
}

/// Gestionnaire de synchronisation automatique en arrière-plan.
@Riverpod(keepAlive: true)
class SyncManager extends _$SyncManager {
  Timer? _periodicTimer;
  Timer? _debounceTimer;
  bool _isSyncing = false;

  @override
  void build() {
    final enabledAsync = ref.watch(autoSyncEnabledProvider);
    final intervalAsync = ref.watch(autoSyncIntervalProvider);
    final authAsync = ref.watch(authStateProvider);

    _cancelTimers();

    final enabled = enabledAsync.value ?? false;
    final interval = intervalAsync.value ?? SyncInterval.fiveMinutes;
    final isLoggedIn = authAsync.value == AuthState.loggedIn;

    if (!enabled || !isLoggedIn) return;

    _periodicTimer = Timer.periodic(
      Duration(minutes: interval.minutes),
      (_) => _performSync(),
    );

    ref.listen(syncTriggerProvider, (prev, next) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(
        const Duration(seconds: 5),
        () => _performSync(),
      );
    });

    ref.onDispose(_cancelTimers);
  }

  /// Appelé quand l'app revient au premier plan.
  void onAppResumed() {
    final enabledAsync = ref.read(autoSyncEnabledProvider);
    final authAsync = ref.read(authStateProvider);

    final enabled = enabledAsync.value ?? false;
    final isLoggedIn = authAsync.value == AuthState.loggedIn;

    if (enabled && isLoggedIn) {
      _performSync();
    }
  }

  Future<void> _performSync() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final syncRepo = await ref.read(syncRepositoryProvider.future);
      final result = await syncRepo.sync();
      debugPrint(
        '[AutoSync] Sync terminée : '
        '${result.pushed.collections} collection(s), ${result.pushed.items} item(s) envoyés — '
        '${result.pulled.collections} collection(s), ${result.pulled.items} item(s) reçus',
      );
    } catch (e) {
      debugPrint('[AutoSync] Erreur de sync : $e');
    } finally {
      _isSyncing = false;
    }
  }

  void _cancelTimers() {
    _periodicTimer?.cancel();
    _periodicTimer = null;
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }
}
