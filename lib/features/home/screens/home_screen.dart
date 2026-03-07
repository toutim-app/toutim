import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';

/// Écran d'accueil — liste des collections de l'utilisateur.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Toutim',
          style: theme.textTheme.headlineMedium,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () {
              // TODO: navigation vers la recherche
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.settings),
            onPressed: () {
              // TODO: navigation vers les paramètres
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.layoutGrid,
                size: 64,
                color: AppColors.textTertiary,
              ),
              const SizedBox(height: 16),
              Text(
                'Aucune collection',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Appuyez sur + pour créer votre première collection',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: création de collection
        },
        backgroundColor: AppColors.blue,
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }
}
