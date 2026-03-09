import 'package:flutter/material.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../data/models/field_definition.dart';

/// Renderer for select field type.
class SelectFieldRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  const SelectFieldRenderer({
    super.key,
    required this.definition,
    this.value,
    required this.onChanged,
  });

  List<String> get _options {
    final opts = definition.options['options'];
    if (opts is List) {
      return opts.cast<String>();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: _options.contains(value) ? value as String : null,
      decoration: InputDecoration(
        labelText: definition.name,
        labelStyle: TextStyle(color: context.appTextSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.appBorder),
        ),
      ),
      items: _options
          .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
          .toList(),
      onChanged: (selected) => onChanged(selected),
    );
  }
}
