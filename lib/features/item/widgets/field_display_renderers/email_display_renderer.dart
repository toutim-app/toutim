import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/field_definition.dart';

/// Read-only display for email fields with tappable mailto link.
class EmailDisplayRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;

  const EmailDisplayRenderer({
    super.key,
    required this.definition,
    required this.value,
  });

  Future<void> _launch() async {
    final uri = Uri(scheme: 'mailto', path: value.toString());
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          definition.name,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: _launch,
          child: Row(
            children: [
              Icon(LucideIcons.mail, size: 18, color: AppColors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.blue,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
