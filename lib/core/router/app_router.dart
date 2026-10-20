import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/collection/screens/collection_detail_screen.dart';
import '../../features/collection/screens/create_collection_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/field_editor/screens/field_editor_screen.dart';
import '../../features/item/screens/item_detail_screen.dart';
import '../../features/item/screens/item_form_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/settings/screens/settings_screen.dart';

part 'app_router.g.dart';

/// Routes nommées de l'application.
abstract final class AppRoutes {
  static const home = '/';
  static const collection = '/collection/:id';
  static const createItem = '/collection/:collectionId/item/new';
  static const viewItem = '/collection/:collectionId/item/:id';
  static const editItem = '/collection/:collectionId/item/:id/edit';
  static const fieldEditor = '/collection/:collectionId/fields';
  static const search = '/search';
  static const createCollection = '/create-collection';
  static const settings = '/settings';
}

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.createCollection,
        name: 'createCollection',
        builder: (context, state) => const CreateCollectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.collection,
        name: 'collection',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CollectionDetailScreen(collectionId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.fieldEditor,
        name: 'fieldEditor',
        builder: (context, state) {
          final collectionId = state.pathParameters['collectionId']!;
          return FieldEditorScreen(collectionId: collectionId);
        },
      ),
      GoRoute(
        path: AppRoutes.createItem,
        name: 'createItem',
        builder: (context, state) {
          final collectionId = state.pathParameters['collectionId']!;
          return ItemFormScreen(collectionId: collectionId);
        },
      ),
      GoRoute(
        path: AppRoutes.viewItem,
        name: 'viewItem',
        builder: (context, state) {
          final collectionId = state.pathParameters['collectionId']!;
          final itemId = state.pathParameters['id']!;
          return ItemDetailScreen(
            collectionId: collectionId,
            itemId: itemId,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.editItem,
        name: 'editItem',
        builder: (context, state) {
          final collectionId = state.pathParameters['collectionId']!;
          final itemId = state.pathParameters['id']!;
          return ItemFormScreen(
            collectionId: collectionId,
            itemId: itemId,
          );
        },
      ),
    ],
  );
}
