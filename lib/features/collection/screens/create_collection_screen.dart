import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/templates/collection_templates.dart';
import '../providers/create_collection_provider.dart';
import '../widgets/custom_collection_form.dart';
import '../widgets/template_selection_grid.dart';

/// Full-screen for creating a new collection (template or custom).
class CreateCollectionScreen extends ConsumerStatefulWidget {
  const CreateCollectionScreen({super.key});

  @override
  ConsumerState<CreateCollectionScreen> createState() =>
      _CreateCollectionScreenState();
}

class _CreateCollectionScreenState
    extends ConsumerState<CreateCollectionScreen> {
  bool _showCustomForm = false;
  bool _isCreating = false;

  Future<void> _createFromTemplate(CollectionTemplate template) async {
    if (_isCreating) return;
    setState(() => _isCreating = true);

    try {
      final service = ref.read(collectionCreationServiceProvider);
      await service.createFromTemplate(template);
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () {
            if (_showCustomForm) {
              setState(() => _showCustomForm = false);
            } else {
              context.pop();
            }
          },
        ),
        title: Text(
          _showCustomForm ? 'Collection personnalisée' : 'Nouvelle collection',
        ),
      ),
      body: _isCreating
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.blue),
                  const SizedBox(height: 16),
                  Text(
                    'Création en cours...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            )
          : _showCustomForm
              ? CustomCollectionForm(
                  onCreated: () => context.pop(),
                )
              : TemplateSelectionGrid(
                  onTemplateSelected: _createFromTemplate,
                  onCustomSelected: () =>
                      setState(() => _showCustomForm = true),
                ),
    );
  }
}
