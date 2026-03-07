import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/enums/field_type.dart';
import '../../../../data/models/field_definition.dart';

/// Renderer for number and currency field types.
class NumberFieldRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  const NumberFieldRenderer({
    super.key,
    required this.definition,
    this.value,
    required this.onChanged,
  });

  bool get _isCurrency => definition.type == FieldType.currency;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value?.toString() ?? '',
      keyboardType: TextInputType.numberWithOptions(
        decimal: _isCurrency,
        signed: false,
      ),
      inputFormatters: _isCurrency
          ? [FilteringTextInputFormatter.allow(RegExp(r'[\d.,]'))]
          : [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: definition.name,
        labelStyle: TextStyle(color: AppColors.textSecondary),
        suffixText: _isCurrency ? '€' : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
      ),
      onChanged: (text) {
        if (text.isEmpty) {
          onChanged(null);
          return;
        }
        if (_isCurrency) {
          final parsed = double.tryParse(text.replaceAll(',', '.'));
          onChanged(parsed);
        } else {
          onChanged(int.tryParse(text));
        }
      },
    );
  }
}
