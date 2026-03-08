// Shared utilities for tracker field renderers (edit & display).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';

/// A single data point in a tracker field.
class TrackerEntry {
  final DateTime date;
  final double value;

  const TrackerEntry({required this.date, required this.value});

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String().split('T').first,
        'value': value,
      };

  factory TrackerEntry.fromJson(Map<String, dynamic> json) {
    return TrackerEntry(
      date: DateTime.parse(json['date'] as String),
      value: (json['value'] as num).toDouble(),
    );
  }
}

List<TrackerEntry> parseTrackerEntries(dynamic value) {
  if (value == null || value is! List) return [];
  return value
      .cast<Map<String, dynamic>>()
      .map((e) => TrackerEntry.fromJson(e))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));
}

List<Map<String, dynamic>> serializeTrackerEntries(List<TrackerEntry> entries) {
  return entries.map((e) => e.toJson()).toList();
}

/// Shows a bottom sheet to add a new tracker entry.
/// Returns the new [TrackerEntry] or null if cancelled.
Future<TrackerEntry?> showAddTrackerEntrySheet(
  BuildContext context, {
  required String unit,
  double? lastValue,
}) {
  return showModalBottomSheet<TrackerEntry>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => AddTrackerEntrySheet(
      unit: unit,
      lastValue: lastValue,
    ),
  );
}

/// Bottom sheet widget for adding a tracker entry.
class AddTrackerEntrySheet extends StatefulWidget {
  final String unit;
  final double? lastValue;

  const AddTrackerEntrySheet({super.key, required this.unit, this.lastValue});

  @override
  State<AddTrackerEntrySheet> createState() => _AddTrackerEntrySheetState();
}

class _AddTrackerEntrySheetState extends State<AddTrackerEntrySheet> {
  late final TextEditingController _valueController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController(
      text: widget.lastValue?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Nouvelle entrée',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _valueController,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
            ],
            decoration: InputDecoration(
              labelText: 'Valeur',
              suffixText: widget.unit.isNotEmpty ? widget.unit : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() => _selectedDate = picked);
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                suffixIcon: Icon(
                  LucideIcons.calendar,
                  color: AppColors.textTertiary,
                ),
              ),
              child: Text(
                DateFormat.yMMMMd('fr_FR').format(_selectedDate),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              final parsed = double.tryParse(
                _valueController.text.replaceAll(',', '.'),
              );
              if (parsed == null) return;
              Navigator.pop(
                context,
                TrackerEntry(date: _selectedDate, value: parsed),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }
}
