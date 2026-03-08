import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/field_definition.dart';
import '../../../data/models/field_value.dart' as models;
import '../../item/providers/item_providers.dart';

/// A card displaying a single item in a collection list.
///
/// Watches its own field values via [itemWithFieldsStreamProvider].
class ItemCard extends ConsumerWidget {
  final String itemId;
  final List<FieldDefinition> fieldDefinitions;
  final VoidCallback? onTap;

  const ItemCard({
    super.key,
    required this.itemId,
    required this.fieldDefinitions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(itemWithFieldsStreamProvider(itemId));

    return itemAsync.when(
      data: (itemWithFields) {
        if (itemWithFields == null) return const SizedBox.shrink();
        return _buildCard(context, itemWithFields.fieldValues);
      },
      loading: () => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.border),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Center(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildCard(
      BuildContext context, Map<String, models.FieldValue> fieldValues) {
    final sorted = [...fieldDefinitions]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    // First required field is the title
    final titleField = sorted.firstWhere(
      (f) => f.isRequired,
      orElse: () => sorted.first,
    );
    final titleValue = fieldValues[titleField.id]?.value;
    final title = _formatValue(titleValue) ?? 'Sans titre';

    // Other showInCard fields for subtitle
    final subtitleParts = <String>[];
    for (final field in sorted) {
      if (field.id == titleField.id) continue;
      if (!field.showInCard) continue;
      final val = fieldValues[field.id]?.value;
      final formatted = _formatValue(val);
      if (formatted != null) {
        subtitleParts.add(formatted);
      }
      if (subtitleParts.length >= 3) break;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitleParts.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitleParts.join(' · '),
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                color: AppColors.textTertiary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _formatValue(dynamic val) {
    if (val == null) return null;
    if (val is bool) return val ? 'Oui' : null;
    if (val is int && val >= 1 && val <= 5) {
      return '${'★' * val}${'☆' * (5 - val)}';
    }
    // Tracker field: show last value
    if (val is List && val.isNotEmpty) {
      final lastEntry = val.last;
      if (lastEntry is Map && lastEntry.containsKey('value')) {
        final v = lastEntry['value'];
        if (v is double && v.truncateToDouble() == v) {
          return v.toInt().toString();
        }
        return v.toString();
      }
    }
    // Barcode field: extract data from Map
    if (val is Map && val.containsKey('data')) {
      final data = val['data']?.toString();
      return (data == null || data.isEmpty) ? null : data;
    }
    final str = val.toString();
    return str.isEmpty ? null : str;
  }
}
