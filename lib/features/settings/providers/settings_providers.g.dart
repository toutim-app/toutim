// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authStateHash() => r'e050191d3388d93cccdb0444c9eae05413227249';

/// Provides the current auth state.
///
/// Copied from [authState].
@ProviderFor(authState)
final authStateProvider = AutoDisposeFutureProvider<AuthState>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateRef = AutoDisposeFutureProviderRef<AuthState>;
String _$serverUrlHash() => r'7fb60809b5c2277246ad62da7979ac0e7e8cb3fe';

/// Provides the current server URL.
///
/// Copied from [serverUrl].
@ProviderFor(serverUrl)
final serverUrlProvider = AutoDisposeFutureProvider<String?>.internal(
  serverUrl,
  name: r'serverUrlProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$serverUrlHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ServerUrlRef = AutoDisposeFutureProviderRef<String?>;
String _$userEmailSettingHash() => r'818692961591cb0533c07f6e853883a9535a4280';

/// Provides the authenticated user's email.
///
/// Copied from [userEmailSetting].
@ProviderFor(userEmailSetting)
final userEmailSettingProvider = AutoDisposeFutureProvider<String?>.internal(
  userEmailSetting,
  name: r'userEmailSettingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userEmailSettingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserEmailSettingRef = AutoDisposeFutureProviderRef<String?>;
String _$syncActionHash() => r'99bb1bd2e8ebaa2ed5b7c76e0c547d336a14dec8';

/// Notifier for sync actions (trigger sync, track state).
///
/// Copied from [SyncAction].
@ProviderFor(SyncAction)
final syncActionProvider =
    AutoDisposeNotifierProvider<SyncAction, AsyncValue<SyncResult?>>.internal(
      SyncAction.new,
      name: r'syncActionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$syncActionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SyncAction = AutoDisposeNotifier<AsyncValue<SyncResult?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
