import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/collection/screens/create_collection_screen.dart';
import '../../features/home/screens/home_screen.dart';

part 'app_router.g.dart';

/// Routes nommées de l'application.
abstract final class AppRoutes {
  static const home = '/';
  static const collection = '/collection/:id';
  static const item = '/collection/:collectionId/item/:id';
  static const createCollection = '/create-collection';
  static const settings = '/settings';
}

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.createCollection,
        name: 'createCollection',
        builder: (context, state) => const CreateCollectionScreen(),
      ),
      // Les routes collection, item et settings seront ajoutées
      // au fur et à mesure du développement des features.
    ],
  );
}
