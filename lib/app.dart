import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_lifecycle_observer.dart';
import 'features/settings/providers/auto_sync_providers.dart';

/// Widget racine de l'application Toutim.
class ToutimApp extends ConsumerStatefulWidget {
  const ToutimApp({super.key});

  @override
  ConsumerState<ToutimApp> createState() => _ToutimAppState();
}

class _ToutimAppState extends ConsumerState<ToutimApp> {
  @override
  void initState() {
    super.initState();
    // Initialise les providers keepAlive au démarrage de l'app.
    Future.microtask(() {
      ref.read(syncManagerProvider);
      ref.read(appLifecycleObserverProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Toutim',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
