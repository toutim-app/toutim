import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/extensions/color_extensions.dart';
import '../../../data/models/field_definition.dart';
import '../providers/filter_providers.dart';

/// Horizontal scrollable bar of filter chips for select/multiSelect/tags fields.
class CollectionFilterBar extends ConsumerWidget {
  final String collectionId;
  final List<FieldDefinition> filterableFields;
  final Color collectionColor;

  const CollectionFilterBar({
    super.key,
    required this.collectionId,
    required this.filterableFields,
    required this.collectionColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(collectionFiltersProvider(collectionId));
    final hasActiveFilters = filters.values.any((s) => s.isNotEmpty);

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          if (hasActiveFilters) ...[
            _ClearAllChip(
              onTap: () => ref
                  .read(collectionFiltersProvider(collectionId).notifier)
                  .state = {},
            ),
            const SizedBox(width: 8),
          ],
          ...filterableFields.map((field) {
            final selected = filters[field.id] ?? {};
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _FilterChip(
                label: field.name,
                isActive: selected.isNotEmpty,
                selectedCount: selected.length,
                collectionColor: collectionColor,
                onTap: () =>
                    _showFilterOptions(context, ref, field, selected),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showFilterOptions(
    BuildContext context,
    WidgetRef ref,
    FieldDefinition field,
    Set<String> currentSelection,
  ) {
    final options =
        (field.options['options'] as List?)?.cast<String>() ?? [];
    if (options.isEmpty) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _FilterOptionsSheet(
        fieldName: field.name,
        options: options,
        initialSelection: currentSelection,
        collectionColor: collectionColor,
        onApply: (newSelection) {
          final current = Map<String, Set<String>>.from(
            ref.read(collectionFiltersProvider(collectionId)),
          );
          if (newSelection.isEmpty) {
            current.remove(field.id);
          } else {
            current[field.id] = newSelection;
          }
          ref.read(collectionFiltersProvider(collectionId).notifier).state =
              current;
        },
      ),
    );
  }
}

class _ClearAllChip extends StatelessWidget {
  final VoidCallback onTap;

  const _ClearAllChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(
          'Effacer',
          style: TextStyle(
            fontSize: 13,
            color: context.appTextSecondary,
          ),
        ),
        deleteIcon: Icon(LucideIcons.x, size: 14, color: context.appTextSecondary),
        onDeleted: onTap,
        side: BorderSide(color: context.appBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final int selectedCount;
  final Color collectionColor;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.selectedCount,
    required this.collectionColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipLabel = isActive ? '$label ($selectedCount)' : label;

    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              chipLabel,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? collectionColor : context.appTextSecondary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              LucideIcons.chevronDown,
              size: 14,
              color: isActive ? collectionColor : context.appTextSecondary,
            ),
          ],
        ),
        backgroundColor:
            isActive ? collectionColor.withValues(alpha: 0.15) : null,
        side: BorderSide(
          color: isActive ? collectionColor.withValues(alpha: 0.3) : context.appBorder,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

class _FilterOptionsSheet extends StatefulWidget {
  final String fieldName;
  final List<String> options;
  final Set<String> initialSelection;
  final Color collectionColor;
  final ValueChanged<Set<String>> onApply;

  const _FilterOptionsSheet({
    required this.fieldName,
    required this.options,
    required this.initialSelection,
    required this.collectionColor,
    required this.onApply,
  });

  @override
  State<_FilterOptionsSheet> createState() => _FilterOptionsSheetState();
}

class _FilterOptionsSheetState extends State<_FilterOptionsSheet> {
  late Set<String> _selection;

  @override
  void initState() {
    super.initState();
    _selection = Set.from(widget.initialSelection);
  }

  bool get _allSelected => _selection.length == widget.options.length;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.appBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.fieldName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.appTextPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    if (_allSelected) {
                      _selection.clear();
                    } else {
                      _selection = Set.from(widget.options);
                    }
                  }),
                  child: Text(
                    _allSelected ? 'Tout désélectionner' : 'Tout sélectionner',
                    style: TextStyle(
                      fontSize: 13,
                      color: widget.collectionColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Options list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.options.length,
              itemBuilder: (context, index) {
                final option = widget.options[index];
                final isSelected = _selection.contains(option);
                return CheckboxListTile(
                  title: Text(
                    option,
                    style: TextStyle(
                      fontSize: 15,
                      color: context.appTextPrimary,
                    ),
                  ),
                  value: isSelected,
                  activeColor: widget.collectionColor,
                  onChanged: (checked) => setState(() {
                    if (checked == true) {
                      _selection.add(option);
                    } else {
                      _selection.remove(option);
                    }
                  }),
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                );
              },
            ),
          ),
          const Divider(height: 1),
          // Apply button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  widget.onApply(_selection);
                  Navigator.pop(context);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: widget.collectionColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Appliquer',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
