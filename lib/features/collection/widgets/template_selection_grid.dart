import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/extensions/color_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/templates/collection_templates.dart';
import 'template_card.dart';

/// Grid displaying all available templates + a "custom" option.
class TemplateSelectionGrid extends StatelessWidget {
  final void Function(CollectionTemplate template) onTemplateSelected;
  final VoidCallback onCustomSelected;

  const TemplateSelectionGrid({
    super.key,
    required this.onTemplateSelected,
    required this.onCustomSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: CollectionTemplates.all.length + 1,
      itemBuilder: (context, index) {
        if (index < CollectionTemplates.all.length) {
          final template = CollectionTemplates.all[index];
          return TemplateCard(
            template: template,
            onTap: () => onTemplateSelected(template),
          );
        }
        return _CustomCard(onTap: onCustomSelected);
      },
    );
  }
}

class _CustomCard extends StatelessWidget {
  final VoidCallback onTap;

  const _CustomCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: context.appBorder,
          style: BorderStyle.solid,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  LucideIcons.plus,
                  color: AppColors.blue,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Personnalisée',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: context.appTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Créer la vôtre',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.appTextTertiary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
