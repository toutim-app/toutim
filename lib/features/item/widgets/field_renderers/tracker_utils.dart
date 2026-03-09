// Shared utilities for tracker field renderers (edit & display).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/extensions/color_extensions.dart';
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

/// Shows a bottom sheet with the full history of tracker entries.
/// Returns the updated list if entries were deleted, or null if unchanged.
Future<List<TrackerEntry>?> showTrackerHistorySheet(
  BuildContext context, {
  required List<TrackerEntry> entries,
  required String unit,
}) {
  return showModalBottomSheet<List<TrackerEntry>>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => TrackerHistorySheet(entries: entries, unit: unit),
  );
}

/// Bottom sheet listing all tracker entries with delete capability.
class TrackerHistorySheet extends StatefulWidget {
  final List<TrackerEntry> entries;
  final String unit;

  const TrackerHistorySheet({
    super.key,
    required this.entries,
    required this.unit,
  });

  @override
  State<TrackerHistorySheet> createState() => _TrackerHistorySheetState();
}

class _TrackerHistorySheetState extends State<TrackerHistorySheet> {
  late List<TrackerEntry> _entries;
  bool _modified = false;

  @override
  void initState() {
    super.initState();
    // Copy and reverse so most recent is on top
    _entries = [...widget.entries];
  }

  void _deleteEntry(int index) {
    setState(() {
      _entries.removeAt(index);
      _modified = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop && _modified) {
          // Return is handled by Navigator.pop in the close button or back gesture
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.appBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Historique',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: context.appTextPrimary,
                                ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(
                          context,
                          _modified ? _entries : null,
                        ),
                        child: Icon(
                          LucideIcons.x,
                          color: context.appTextTertiary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            Expanded(
              child: _entries.isEmpty
                  ? Center(
                      child: Text(
                        'Aucune entrée',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: context.appTextTertiary,
                                ),
                      ),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: _entries.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        color: context.appBorder,
                      ),
                      itemBuilder: (context, index) {
                        // Show most recent first
                        final reversedIndex = _entries.length - 1 - index;
                        final entry = _entries[reversedIndex];
                        final formattedValue =
                            entry.value.truncateToDouble() == entry.value
                                ? entry.value.toInt().toString()
                                : entry.value.toStringAsFixed(1);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$formattedValue${widget.unit.isNotEmpty ? ' ${widget.unit}' : ''}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: context.appTextPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      DateFormat.yMMMd('fr_FR')
                                          .format(entry.date),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: context.appTextTertiary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _deleteEntry(reversedIndex),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    LucideIcons.trash2,
                                    size: 18,
                                    color: AppColors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
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
                color: context.appBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Nouvelle entrée',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.appTextPrimary,
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
                borderSide: BorderSide(color: context.appBorder),
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
                  borderSide: BorderSide(color: context.appBorder),
                ),
                suffixIcon: Icon(
                  LucideIcons.calendar,
                  color: context.appTextTertiary,
                ),
              ),
              child: Text(
                DateFormat.yMMMMd('fr_FR').format(_selectedDate),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: context.appTextPrimary,
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
