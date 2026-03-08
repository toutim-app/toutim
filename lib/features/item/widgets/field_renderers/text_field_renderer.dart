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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _extractData(widget.value));
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

  Future<void> _scan() async {
    final result = await Navigator.push<_ScanResult>(
      context,
      MaterialPageRoute(builder: (_) => const _BarcodeScannerScreen()),
    );
    if (result != null && mounted) {
      _controller.text = result.data;
      widget.onChanged({
        'data': result.data,
        'format': result.format,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
          // Manual input: keep existing format if any, default to code128
          final existingFormat =
              widget.value is Map ? widget.value['format'] : null;
          widget.onChanged(text.isEmpty
              ? null
              : {
                  'data': text,
                  'format': existingFormat ?? 'code128',
                });
        } else {
          widget.onChanged(text.isEmpty ? null : text);
        }
      },
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
