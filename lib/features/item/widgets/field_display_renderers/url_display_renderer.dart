import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/field_definition.dart';

/// Read-only display for URL fields with tappable link.
class UrlDisplayRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;

  const UrlDisplayRenderer({
    super.key,
    required this.definition,
    required this.value,
  });

  Future<void> _launch() async {
    var urlStr = value.toString();
    if (!urlStr.startsWith('http://') && !urlStr.startsWith('https://')) {
      urlStr = 'https://$urlStr';
    }
    final uri = Uri.tryParse(urlStr);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
              Icon(LucideIcons.externalLink, size: 18, color: AppColors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.blue,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
