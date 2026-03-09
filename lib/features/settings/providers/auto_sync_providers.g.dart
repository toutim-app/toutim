// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$autoSyncEnabledHash() => r'7662cd5526107c9b10a8169a7a2f2146d7537eb6';

/// Préférence : sync automatique activée ou non.
///
/// Copied from [AutoSyncEnabled].
@ProviderFor(AutoSyncEnabled)
final autoSyncEnabledProvider =
    AsyncNotifierProvider<AutoSyncEnabled, bool>.internal(
      AutoSyncEnabled.new,
      name: r'autoSyncEnabledProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$autoSyncEnabledHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AutoSyncEnabled = AsyncNotifier<bool>;
String _$autoSyncIntervalHash() => r'84617fc7e52e3506d1fa840e59df413cc56ed9d3';

/// Préférence : intervalle de sync automatique.
///
/// Copied from [AutoSyncInterval].
@ProviderFor(AutoSyncInterval)
final autoSyncIntervalProvider =
    AsyncNotifierProvider<AutoSyncInterval, SyncInterval>.internal(
      AutoSyncInterval.new,
      name: r'autoSyncIntervalProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$autoSyncIntervalHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AutoSyncInterval = AsyncNotifier<SyncInterval>;
String _$syncTriggerHash() => r'ecf77ed73977f0299c4675b64588a6a7fe4bfa7d';

/// Compteur incrémenté à chaque modification locale.
/// Le SyncManager écoute ce provider pour déclencher une sync debounced.
///
/// Copied from [SyncTrigger].
@ProviderFor(SyncTrigger)
final syncTriggerProvider = NotifierProvider<SyncTrigger, int>.internal(
  SyncTrigger.new,
  name: r'syncTriggerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$syncTriggerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SyncTrigger = Notifier<int>;
String _$syncManagerHash() => r'10de3337304f065bd9f67e08a56f3c011c0a1659';

/// Gestionnaire de synchronisation automatique en arrière-plan.
///
/// Copied from [SyncManager].
@ProviderFor(SyncManager)
final syncManagerProvider = NotifierProvider<SyncManager, void>.internal(
  SyncManager.new,
  name: r'syncManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$syncManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SyncManager = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
