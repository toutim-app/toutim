// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_lifecycle_observer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Observe le cycle de vie de l'app pour déclencher une sync au retour
/// au premier plan.

@ProviderFor(appLifecycleObserver)
final appLifecycleObserverProvider = AppLifecycleObserverProvider._();

/// Observe le cycle de vie de l'app pour déclencher une sync au retour
/// au premier plan.

final class AppLifecycleObserverProvider
    extends $FunctionalProvider<Raw, Raw, Raw>
    with $Provider<Raw> {
  /// Observe le cycle de vie de l'app pour déclencher une sync au retour
  /// au premier plan.
  AppLifecycleObserverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLifecycleObserverProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLifecycleObserverHash();

  @$internal
  @override
  $ProviderElement<Raw> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Raw create(Ref ref) {
    return appLifecycleObserver(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw>(value),
    );
  }
}

String _$appLifecycleObserverHash() =>
    r'8305bb78b0cec7afd25a64b86d99a986eb17d7d3';
