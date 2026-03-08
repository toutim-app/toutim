import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/enums/field_type.dart';
import '../../../../data/models/field_definition.dart';

/// Maps mobile_scanner BarcodeFormat to a storage key.
String? _barcodeFormatKey(BarcodeFormat format) {
  return switch (format) {
    BarcodeFormat.ean13 => 'ean13',
    BarcodeFormat.ean8 => 'ean8',
    BarcodeFormat.upcA => 'upcA',
    BarcodeFormat.upcE => 'upcE',
    BarcodeFormat.code39 => 'code39',
    BarcodeFormat.code93 => 'code93',
    BarcodeFormat.code128 => 'code128',
    BarcodeFormat.qrCode => 'qrCode',
    BarcodeFormat.aztec => 'aztec',
    BarcodeFormat.dataMatrix => 'dataMatrix',
    BarcodeFormat.pdf417 => 'pdf417',
    BarcodeFormat.itf => 'itf',
    _ => null,
  };
}

/// User-selectable barcode formats with display labels.
const _barcodeFormats = [
  ('code128', 'Code 128'),
  ('ean13', 'EAN-13'),
  ('ean8', 'EAN-8'),
  ('qrCode', 'QR Code'),
  ('upcA', 'UPC-A'),
  ('upcE', 'UPC-E'),
  ('code39', 'Code 39'),
  ('code93', 'Code 93'),
  ('aztec', 'Aztec'),
  ('dataMatrix', 'Data Matrix'),
  ('pdf417', 'PDF 417'),
  ('itf', 'ITF'),
];

/// Hint text describing expected data format for each barcode type.
String? _formatHint(String format) {
  return switch (format) {
    'ean13' => '13 chiffres (ex: 3760012345678)',
    'ean8' => '8 chiffres (ex: 96385074)',
    'upcA' => '12 chiffres',
    'upcE' => '8 chiffres',
    'code128' => 'Texte ou chiffres (format universel)',
    'qrCode' => 'Texte libre',
    'itf' => 'Nombre pair de chiffres',
    _ => null,
  };
}

/// Renderer for text and barcode field types.
class TextFieldRenderer extends StatefulWidget {
  final FieldDefinition definition;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  const TextFieldRenderer({
    super.key,
    required this.definition,
    this.value,
    required this.onChanged,
  });

  @override
  State<TextFieldRenderer> createState() => _TextFieldRendererState();
}

class _TextFieldRendererState extends State<TextFieldRenderer> {
  late final TextEditingController _controller;
  late String _barcodeFormat;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _extractData(widget.value));
    _barcodeFormat = _extractFormat(widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isBarcode =>
      widget.definition.type == FieldType.barcode ||
      widget.definition.type == FieldType.qrCode;

  /// Extracts the text data from a barcode value (Map or plain String).
  static String _extractData(dynamic value) {
    if (value is Map) return (value['data'] as String?) ?? '';
    return value as String? ?? '';
  }

  /// Extracts the barcode format from a value, defaulting to code128.
  static String _extractFormat(dynamic value) {
    if (value is Map) return (value['format'] as String?) ?? 'code128';
    return 'code128';
  }

  Future<void> _scan() async {
    final result = await Navigator.push<_ScanResult>(
      context,
      MaterialPageRoute(builder: (_) => const _BarcodeScannerScreen()),
    );
    if (result != null && mounted) {
      _controller.text = result.data;
      setState(() => _barcodeFormat = result.format);
      widget.onChanged({
        'data': result.data,
        'format': result.format,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textField = TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.definition.name,
        labelStyle: TextStyle(color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        suffixIcon: _isBarcode
            ? IconButton(
                icon: Icon(LucideIcons.scanLine, color: AppColors.blue),
                onPressed: _scan,
              )
            : null,
      ),
      onChanged: (text) {
        if (_isBarcode) {
          widget.onChanged(text.isEmpty
              ? null
              : {
                  'data': text,
                  'format': _barcodeFormat,
                });
        } else {
          widget.onChanged(text.isEmpty ? null : text);
        }
      },
    );

    if (!_isBarcode) return textField;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textField,
        const SizedBox(height: 8),
        DropdownMenu<String>(
          key: ValueKey(_barcodeFormat),
          initialSelection: _barcodeFormat,
          label: Text('Type de code',
              style: TextStyle(color: AppColors.textSecondary)),
          expandedInsets: EdgeInsets.zero,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          dropdownMenuEntries: _barcodeFormats
              .map((entry) => DropdownMenuEntry(
                    value: entry.$1,
                    label: entry.$2,
                  ))
              .toList(),
          onSelected: (format) {
            if (format == null) return;
            setState(() => _barcodeFormat = format);
            final text = _controller.text;
            if (text.isNotEmpty) {
              widget.onChanged({
                'data': text,
                'format': format,
              });
            }
          },
        ),
        if (_formatHint(_barcodeFormat) != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              _formatHint(_barcodeFormat)!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
            ),
          ),
      ],
    );
  }
}

class _ScanResult {
  final String data;
  final String format;
  const _ScanResult({required this.data, required this.format});
}

/// Full-screen barcode scanner overlay.
class _BarcodeScannerScreen extends StatefulWidget {
  const _BarcodeScannerScreen();

  @override
  State<_BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<_BarcodeScannerScreen> {
  bool _scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner un code'),
        leading: IconButton(
          icon: const Icon(LucideIcons.x),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (_scanned) return;
          final barcodes = capture.barcodes;
          if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
            _scanned = true;
            final barcode = barcodes.first;
            final formatKey = _barcodeFormatKey(barcode.format) ?? 'code128';
            Navigator.pop(
              context,
              _ScanResult(data: barcode.rawValue!, format: formatKey),
            );
          }
        },
      ),
    );
  }
}
