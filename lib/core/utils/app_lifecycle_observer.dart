import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/settings/providers/auto_sync_providers.dart';

part 'app_lifecycle_observer.g.dart';

class _LifecycleObserver with WidgetsBindingObserver {
  _LifecycleObserver(this._ref);

  final Ref _ref;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _ref.read(syncManagerProvider.notifier).onAppResumed();
    }
  }
}

/// Observe le cycle de vie de l'app pour déclencher une sync au retour
/// au premier plan.
@Riverpod(keepAlive: true)
Raw appLifecycleObserver(AppLifecycleObserverRef ref) {
  final observer = _LifecycleObserver(ref);
  WidgetsBinding.instance.addObserver(observer);
  ref.onDispose(() {
    WidgetsBinding.instance.removeObserver(observer);
  });
  return const Raw._();
}

/// Type opaque pour le provider lifecycle (pas de valeur utile exposée).
class Raw {
  const Raw._();
}
