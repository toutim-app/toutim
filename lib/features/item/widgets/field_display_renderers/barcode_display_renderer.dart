import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/enums/field_type.dart';
import '../../../../data/models/field_definition.dart';

/// Read-only display for barcode and QR code fields.
/// Renders a visual barcode/QR code using barcode_widget.
///
/// Value format: `{data: "...", format: "ean13"}` or plain `String` (legacy).
class BarcodeDisplayRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;

  const BarcodeDisplayRenderer({
    super.key,
    required this.definition,
    required this.value,
  });

  String get _data {
    if (value is Map) return (value['data'] as String?) ?? '';
    return value?.toString() ?? '';
  }

  String? get _format {
    if (value is Map) return value['format'] as String?;
    return null;
  }

  Barcode _resolveBarcode() {
    // QR code field type always renders as QR
    if (definition.type == FieldType.qrCode) {
      return Barcode.qrCode();
    }

    // Use detected/stored format
    final fmt = _format;
    return switch (fmt) {
      'ean13' => Barcode.ean13(),
      'ean8' => Barcode.ean8(),
      'upcA' => Barcode.upcA(),
      'upcE' => Barcode.upcE(),
      'code39' => Barcode.code39(),
      'code93' => Barcode.code93(),
      'code128' => Barcode.code128(),
      'qrCode' => Barcode.qrCode(),
      'aztec' => Barcode.aztec(),
      'dataMatrix' => Barcode.dataMatrix(),
      'pdf417' => Barcode.pdf417(),
      'itf' => Barcode.itf(),
      _ => Barcode.code128(),
    };
  }

  bool get _isQrLike {
    final fmt = _format;
    return definition.type == FieldType.qrCode ||
        fmt == 'qrCode' ||
        fmt == 'aztec' ||
        fmt == 'dataMatrix';
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    if (data.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          definition.name,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.appTextSecondary,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.appSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.appBorder),
          ),
          child: Column(
            children: [
              BarcodeWidget(
                barcode: _resolveBarcode(),
                data: data,
                width: _isQrLike ? 180 : double.infinity,
                height: _isQrLike ? 180 : 80,
                color: context.appTextPrimary,
                backgroundColor: context.appSurface,
                drawText: false,
                errorBuilder: (context, error) => Column(
                  children: [
                    Text(
                      data,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: context.appTextPrimary,
                            fontFamily: 'monospace',
                            letterSpacing: 2,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Format incompatible avec les données',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.orange,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.appTextSecondary,
                      letterSpacing: 2,
                      fontFamily: 'monospace',
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
