import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/enums/field_type.dart';
import '../../../../data/models/field_definition.dart';
import 'boolean_field_renderer.dart';
import 'date_field_renderer.dart';
import 'image_field_renderer.dart';
import 'number_field_renderer.dart';
import 'rating_field_renderer.dart';
import 'select_field_renderer.dart';
import 'text_area_renderer.dart';
import 'text_field_renderer.dart';
import 'tags_field_renderer.dart';
import 'tracker_field_renderer.dart';
import 'unsupported_field_renderer.dart';

/// Builds the appropriate field renderer widget for a given field definition.
Widget buildFieldRenderer({
  required FieldDefinition definition,
  required dynamic value,
  required ValueChanged<dynamic> onChanged,
  Color? collectionColor,
}) {
  return switch (definition.type) {
    FieldType.text || FieldType.barcode || FieldType.url ||
    FieldType.email || FieldType.phone =>
      TextFieldRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
        onChanged: onChanged,
      ),
    FieldType.textArea =>
      TextAreaRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
        onChanged: onChanged,
      ),
    FieldType.number || FieldType.currency || FieldType.decimal =>
      NumberFieldRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
        onChanged: onChanged,
      ),
    FieldType.boolean =>
      BooleanFieldRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
        onChanged: onChanged,
      ),
    FieldType.date || FieldType.dateTime =>
      DateFieldRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
        onChanged: onChanged,
      ),
    FieldType.select =>
      SelectFieldRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
        onChanged: onChanged,
      ),
    FieldType.rating =>
      RatingFieldRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
        onChanged: onChanged,
      ),
    FieldType.image =>
      ImageFieldRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
        onChanged: onChanged,
      ),
    FieldType.tracker =>
      TrackerFieldRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
        onChanged: onChanged,
        collectionColor: collectionColor ?? AppColors.blue,
      ),
    FieldType.tags =>
      TagsFieldRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
        onChanged: onChanged,
      ),
    _ =>
      UnsupportedFieldRenderer(
        key: ValueKey(definition.id),
        definition: definition,
      ),
  };
}
