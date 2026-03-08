import 'package:flutter/material.dart';

import '../../../../data/models/enums/field_type.dart';
import '../../../../data/models/field_definition.dart';
import 'barcode_display_renderer.dart';
import 'boolean_display_renderer.dart';
import 'date_display_renderer.dart';
import 'email_display_renderer.dart';
import 'image_display_renderer.dart';
import 'number_display_renderer.dart';
import 'phone_display_renderer.dart';
import 'rating_display_renderer.dart';
import 'select_display_renderer.dart';
import 'text_area_display_renderer.dart';
import 'text_display_renderer.dart';
import 'tracker_display_renderer.dart';
import 'unsupported_display_renderer.dart';
import 'url_display_renderer.dart';

/// Builds the appropriate read-only display widget for a given field.
///
/// [onChanged] is optional and only used by interactive display renderers
/// (e.g. tracker) to persist changes directly from the detail view.
Widget buildFieldDisplayRenderer({
  required FieldDefinition definition,
  required dynamic value,
  required Color collectionColor,
  ValueChanged<dynamic>? onChanged,
}) {
  return switch (definition.type) {
    FieldType.text => TextDisplayRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
      ),
    FieldType.textArea => TextAreaDisplayRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
      ),
    FieldType.number || FieldType.currency || FieldType.decimal =>
      NumberDisplayRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
      ),
    FieldType.boolean => BooleanDisplayRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
        collectionColor: collectionColor,
      ),
    FieldType.date || FieldType.dateTime => DateDisplayRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
        collectionColor: collectionColor,
      ),
    FieldType.select => SelectDisplayRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
        collectionColor: collectionColor,
      ),
    FieldType.rating => RatingDisplayRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
      ),
    FieldType.image => ImageDisplayRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
      ),
    FieldType.barcode || FieldType.qrCode => BarcodeDisplayRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
      ),
    FieldType.url => UrlDisplayRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
      ),
    FieldType.email => EmailDisplayRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
      ),
    FieldType.phone => PhoneDisplayRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
      ),
    FieldType.tracker => TrackerDisplayRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
        collectionColor: collectionColor,
        onChanged: onChanged,
      ),
    _ => UnsupportedDisplayRenderer(
        key: ValueKey(definition.id),
        definition: definition,
        value: value,
      ),
  };
}
