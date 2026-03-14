import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/extensions/color_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/enums/field_type.dart';
import '../../../data/models/field_definition.dart';
import '../../../data/models/field_value.dart' as models;
import '../../item/providers/item_providers.dart';

/// A card displaying a single item in a collection list.
///
/// Shows a rich layout with optional image thumbnail, visual star rating,
/// and boolean status chips when available.
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
          side: BorderSide(color: context.appBorder),
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

    // --- Categorize fields ---

    // Title: first required field (or first field)
    final titleField = sorted.firstWhere(
      (f) => f.isRequired,
      orElse: () => sorted.first,
    );
    final titleValue = fieldValues[titleField.id]?.value;
    final title = _formatTextValue(titleValue, titleField) ?? 'Sans titre';

    // Image: first image field with showInCard
    String? imagePath;
    String imageDisplayMode = 'square';
    for (final field in sorted) {
      if (field.type == FieldType.image && field.showInCard) {
        final val = fieldValues[field.id]?.value;
        if (val is String && val.isNotEmpty && File(val).existsSync()) {
          imagePath = val;
          imageDisplayMode =
              field.options['imageDisplayMode'] as String? ?? 'square';
          break;
        }
      }
    }

    // Rating: first rating field with showInCard
    int? ratingValue;
    for (final field in sorted) {
      if (field.type == FieldType.rating && field.showInCard) {
        final val = fieldValues[field.id]?.value;
        if (val is int && val >= 1 && val <= 5) {
          ratingValue = val;
        }
        break;
      }
    }

    // Booleans with true value and showInCard
    final booleanChips = <String>[];
    for (final field in sorted) {
      if (field.type == FieldType.boolean && field.showInCard) {
        final val = fieldValues[field.id]?.value;
        if (val == true) {
          booleanChips.add(field.name);
        }
      }
    }

    // Subtitle: other showInCard text fields (not image, rating, boolean, title)
    final subtitleParts = <String>[];
    const skipTypes = {
      FieldType.image,
      FieldType.rating,
      FieldType.boolean,
    };
    for (final field in sorted) {
      if (field.id == titleField.id) continue;
      if (!field.showInCard) continue;
      if (skipTypes.contains(field.type)) continue;
      final val = fieldValues[field.id]?.value;
      final formatted = _formatTextValue(val, field);
      if (formatted != null) {
        subtitleParts.add(formatted);
      }
      if (subtitleParts.length >= 3) break;
    }

    final hasBottomRow = ratingValue != null || booleanChips.isNotEmpty;

    // --- Build layout ---
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.appBorder),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Thumbnail
              if (imagePath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(imagePath),
                    width: switch (imageDisplayMode) {
                      'banner' => 110.0,
                      _ => 70.0,
                    },
                    height: switch (imageDisplayMode) {
                      'poster' => 100.0,
                      'banner' => 70.0,
                      _ => 70.0, // square
                    },
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: context.appTextPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitleParts.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitleParts.join(' | '),
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: context.appTextSecondary,
                                ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (hasBottomRow) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          // Rating stars
                          if (ratingValue case final rating?)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(5, (index) {
                                final isFilled = (index + 1) <= rating;
                                return Icon(
                                  LucideIcons.star,
                                  color: isFilled
                                      ? AppColors.yellow
                                      : context.appBorder,
                                  size: 16,
                                );
                              }),
                            ),
                          const Spacer(),
                          // Boolean chips
                          ...booleanChips.map((label) => Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.green.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    label,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: AppColors.green,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Formats a field value as text for the subtitle.
  /// Skips image, rating and boolean fields (handled separately).
  String? _formatTextValue(dynamic val, FieldDefinition field) {
    if (val == null) return null;
    if (val is bool) return null; // handled as chips
    // Tracker field: show last value with unit
    if (val is List && val.isNotEmpty) {
      final lastEntry = val.last;
      if (lastEntry is Map && lastEntry.containsKey('value')) {
        final v = lastEntry['value'];
        final unit = field.options['unit'] as String? ?? '';
        String formatted;
        if (v is double && v.truncateToDouble() == v) {
          formatted = v.toInt().toString();
        } else {
          formatted = v.toString();
        }
        return unit.isNotEmpty ? '$formatted $unit' : formatted;
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
