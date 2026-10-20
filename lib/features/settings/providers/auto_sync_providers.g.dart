// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Préférence : sync automatique activée ou non.

@ProviderFor(AutoSyncEnabled)
final autoSyncEnabledProvider = AutoSyncEnabledProvider._();

/// Préférence : sync automatique activée ou non.
final class AutoSyncEnabledProvider
    extends $AsyncNotifierProvider<AutoSyncEnabled, bool> {
  /// Préférence : sync automatique activée ou non.
  AutoSyncEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoSyncEnabledProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoSyncEnabledHash();

  @$internal
  @override
  AutoSyncEnabled create() => AutoSyncEnabled();
}

String _$autoSyncEnabledHash() => r'7662cd5526107c9b10a8169a7a2f2146d7537eb6';

/// Préférence : sync automatique activée ou non.

abstract class _$AutoSyncEnabled extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Préférence : intervalle de sync automatique.

@ProviderFor(AutoSyncInterval)
final autoSyncIntervalProvider = AutoSyncIntervalProvider._();

/// Préférence : intervalle de sync automatique.
final class AutoSyncIntervalProvider
    extends $AsyncNotifierProvider<AutoSyncInterval, SyncInterval> {
  /// Préférence : intervalle de sync automatique.
  AutoSyncIntervalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoSyncIntervalProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoSyncIntervalHash();

  @$internal
  @override
  AutoSyncInterval create() => AutoSyncInterval();
}

String _$autoSyncIntervalHash() => r'84617fc7e52e3506d1fa840e59df413cc56ed9d3';

/// Préférence : intervalle de sync automatique.

abstract class _$AutoSyncInterval extends $AsyncNotifier<SyncInterval> {
  FutureOr<SyncInterval> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SyncInterval>, SyncInterval>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SyncInterval>, SyncInterval>,
              AsyncValue<SyncInterval>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Compteur incrémenté à chaque modification locale.
/// Le SyncManager écoute ce provider pour déclencher une sync debounced.

@ProviderFor(SyncTrigger)
final syncTriggerProvider = SyncTriggerProvider._();

/// Compteur incrémenté à chaque modification locale.
/// Le SyncManager écoute ce provider pour déclencher une sync debounced.
final class SyncTriggerProvider extends $NotifierProvider<SyncTrigger, int> {
  /// Compteur incrémenté à chaque modification locale.
  /// Le SyncManager écoute ce provider pour déclencher une sync debounced.
  SyncTriggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncTriggerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncTriggerHash();

  @$internal
  @override
  SyncTrigger create() => SyncTrigger();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$syncTriggerHash() => r'ecf77ed73977f0299c4675b64588a6a7fe4bfa7d';

/// Compteur incrémenté à chaque modification locale.
/// Le SyncManager écoute ce provider pour déclencher une sync debounced.

abstract class _$SyncTrigger extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Gestionnaire de synchronisation automatique en arrière-plan.

@ProviderFor(SyncManager)
final syncManagerProvider = SyncManagerProvider._();

/// Gestionnaire de synchronisation automatique en arrière-plan.
final class SyncManagerProvider extends $NotifierProvider<SyncManager, void> {
  /// Gestionnaire de synchronisation automatique en arrière-plan.
  SyncManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncManagerHash();

  @$internal
  @override
  SyncManager create() => SyncManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$syncManagerHash() => r'04c221af47aa4995bcbd279c9aa83b307ff666d3';

/// Gestionnaire de synchronisation automatique en arrière-plan.

abstract class _$SyncManager extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
