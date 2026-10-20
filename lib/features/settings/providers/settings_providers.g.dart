// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the current auth state.

@ProviderFor(authState)
final authStateProvider = AuthStateProvider._();

/// Provides the current auth state.

final class AuthStateProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthState>,
          AuthState,
          FutureOr<AuthState>
        >
    with $FutureModifier<AuthState>, $FutureProvider<AuthState> {
  /// Provides the current auth state.
  AuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateHash();

  @$internal
  @override
  $FutureProviderElement<AuthState> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AuthState> create(Ref ref) {
    return authState(ref);
  }
}

String _$authStateHash() => r'e496f23757531043acdcad76fdf78a1ff4505660';

/// Provides the current server URL.

@ProviderFor(serverUrl)
final serverUrlProvider = ServerUrlProvider._();

/// Provides the current server URL.

final class ServerUrlProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// Provides the current server URL.
  ServerUrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverUrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverUrlHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return serverUrl(ref);
  }
}

String _$serverUrlHash() => r'49f8ca3adf135e6ca0ac80424e6acbbc29e37cac';

/// Provides the authenticated user's email.

@ProviderFor(userEmailSetting)
final userEmailSettingProvider = UserEmailSettingProvider._();

/// Provides the authenticated user's email.

final class UserEmailSettingProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// Provides the authenticated user's email.
  UserEmailSettingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userEmailSettingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userEmailSettingHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return userEmailSetting(ref);
  }
}

String _$userEmailSettingHash() => r'd5d75e219415929146ed026427ffcb79300ab581';

/// Notifier for sync actions (trigger sync, track state).

@ProviderFor(SyncAction)
final syncActionProvider = SyncActionProvider._();

/// Notifier for sync actions (trigger sync, track state).
final class SyncActionProvider
    extends $NotifierProvider<SyncAction, AsyncValue<SyncResult?>> {
  /// Notifier for sync actions (trigger sync, track state).
  SyncActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncActionHash();

  @$internal
  @override
  SyncAction create() => SyncAction();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<SyncResult?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<SyncResult?>>(value),
    );
  }
}

String _$syncActionHash() => r'99bb1bd2e8ebaa2ed5b7c76e0c547d336a14dec8';

/// Notifier for sync actions (trigger sync, track state).

abstract class _$SyncAction extends $Notifier<AsyncValue<SyncResult?>> {
  AsyncValue<SyncResult?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SyncResult?>, AsyncValue<SyncResult?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SyncResult?>, AsyncValue<SyncResult?>>,
              AsyncValue<SyncResult?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
