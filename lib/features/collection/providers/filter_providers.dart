import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/enums/field_type.dart';
import '../../../data/models/field_definition.dart';
import '../../../data/models/item_with_fields.dart';
import '../../../data/providers/repository_providers.dart';
import 'collection_providers.dart';

part 'filter_providers.g.dart';

/// Active filters per collection (fieldDefinitionId -> selected values).
/// Empty map means no filters active.
final collectionFiltersProvider =
    StateProvider.family<Map<String, Set<String>>, String>(
  (ref, collectionId) => {},
);

/// Watches all items with their field values for a collection.
@riverpod
Stream<List<ItemWithFields>> allItemsWithFieldsStream(
  AllItemsWithFieldsStreamRef ref,
  String collectionId,
) {
  return ref
      .watch(itemRepositoryProvider)
      .watchAllItemsWithFields(collectionId);
}

/// Field types that support filtering.
const _filterableTypes = {
  FieldType.select,
  FieldType.multiSelect,
  FieldType.tags,
};

/// Extracts field definitions that can be used as filters.
/// - select/multiSelect: require predefined options in field definition
/// - tags: always filterable (options are derived from item values at runtime)
@riverpod
List<FieldDefinition> filterableFields(
  FilterableFieldsRef ref,
  String collectionId,
) {
  final fieldsAsync = ref.watch(fieldDefinitionsStreamProvider(collectionId));
  return fieldsAsync.when(
    data: (fields) => fields.where((f) {
      if (!_filterableTypes.contains(f.type)) return false;
      if (f.type == FieldType.tags) return true;
      final opts = f.options['options'];
      return opts is List && opts.isNotEmpty;
    }).toList(),
    loading: () => [],
    error: (_, _) => [],
  );
}

/// Collects unique tag values used across all items for each tags field.
/// Returns a map of fieldDefinitionId -> sorted list of unique tag strings.
@riverpod
Map<String, List<String>> uniqueTagValues(
  UniqueTagValuesRef ref,
  String collectionId,
) {
  final allItemsAsync =
      ref.watch(allItemsWithFieldsStreamProvider(collectionId));
  return allItemsAsync.when(
    data: (items) {
      final result = <String, Set<String>>{};
      for (final item in items) {
        for (final entry in item.fieldValues.entries) {
          final val = entry.value.value;
          if (val is List) {
            final strings = val.whereType<String>().toList();
            if (strings.isNotEmpty) {
              result.putIfAbsent(entry.key, () => {}).addAll(strings);
            }
          }
        }
      }
      return result.map((k, v) => MapEntry(k, v.toList()..sort()));
    },
    loading: () => {},
    error: (_, _) => {},
  );
}

/// Provides the filtered list of items.
/// OR logic within a field, AND logic between fields.
@riverpod
List<ItemWithFields> filteredItems(
  FilteredItemsRef ref,
  String collectionId,
) {
  final allItemsAsync =
      ref.watch(allItemsWithFieldsStreamProvider(collectionId));
  final filters = ref.watch(collectionFiltersProvider(collectionId));

  return allItemsAsync.when(
    data: (items) {
      if (filters.isEmpty) return items;

      return items.where((item) {
        for (final entry in filters.entries) {
          final fieldDefId = entry.key;
          final selectedValues = entry.value;
          if (selectedValues.isEmpty) continue;

          final fieldValue = item.fieldValues[fieldDefId]?.value;
          if (fieldValue == null) return false;

          if (fieldValue is String) {
            if (!selectedValues.contains(fieldValue)) return false;
          } else if (fieldValue is List) {
            final itemValues = fieldValue.cast<String>().toSet();
            if (itemValues.intersection(selectedValues).isEmpty) return false;
          } else {
            return false;
          }
        }
        return true;
      }).toList();
    },
    loading: () => [],
    error: (_, _) => [],
  );
}
