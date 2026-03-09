import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/router/app_router.dart';
import '../../../core/extensions/color_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/home_providers.dart';
import '../widgets/home_collection_list.dart';
import '../widgets/home_empty_state.dart';

/// Home screen — displays the user's collections.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(collectionsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icon/app_icon_foreground.png',
              width: 38,
              height: 38,
            ),
            const SizedBox(width: 10),
            Text(
              'Toutim',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () => context.push(AppRoutes.search),
          ),
          IconButton(
            icon: const Icon(LucideIcons.settings),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: collectionsAsync.when(
        data: (collections) => collections.isEmpty
            ? const HomeEmptyState()
            : HomeCollectionList(collections: collections),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Une erreur est survenue',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.appTextSecondary,
                ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.createCollection),
        backgroundColor: AppColors.blue,
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }
}
