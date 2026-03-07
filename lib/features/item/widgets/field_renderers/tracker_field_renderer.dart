import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/field_definition.dart';

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

List<TrackerEntry> _parseEntries(dynamic value) {
  if (value == null || value is! List) return [];
  return value
      .cast<Map<String, dynamic>>()
      .map((e) => TrackerEntry.fromJson(e))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));
}

List<Map<String, dynamic>> _serializeEntries(List<TrackerEntry> entries) {
  return entries.map((e) => e.toJson()).toList();
}

/// Renderer for tracker field type — stores a history of numeric values
/// with dates and displays a mini line chart.
class TrackerFieldRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  const TrackerFieldRenderer({
    super.key,
    required this.definition,
    this.value,
    required this.onChanged,
  });

  String get _unit => definition.options['unit'] as String? ?? '';

  bool get _upIsGood =>
      (definition.options['improvementDirection'] as String? ?? 'up') == 'up';

  @override
  Widget build(BuildContext context) {
    final entries = _parseEntries(value);
    final lastEntry = entries.isNotEmpty ? entries.last : null;
    final previousEntry =
        entries.length >= 2 ? entries[entries.length - 2] : null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, entries),
          if (lastEntry != null) ...[
            const SizedBox(height: 12),
            _buildLastValue(context, lastEntry, previousEntry),
          ],
          if (entries.length >= 2) ...[
            const SizedBox(height: 12),
            _buildChart(entries),
          ],
          if (entries.isEmpty) _buildEmptyState(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<TrackerEntry> entries) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          definition.name,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        GestureDetector(
          onTap: () => _showAddEntrySheet(context, entries),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.plus, size: 16, color: AppColors.blue),
                const SizedBox(width: 4),
                Text(
                  'Ajouter',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLastValue(
      BuildContext context, TrackerEntry last, TrackerEntry? previous) {
    final diff = previous != null ? last.value - previous.value : null;
    final formattedValue = last.value.truncateToDouble() == last.value
        ? last.value.toInt().toString()
        : last.value.toStringAsFixed(1);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$formattedValue${_unit.isNotEmpty ? ' $_unit' : ''}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
        if (diff != null && diff != 0) ...[
          const SizedBox(width: 8),
          _buildTrendIndicator(context, diff),
        ],
        const Spacer(),
        Text(
          DateFormat.yMMMd('fr_FR').format(last.date),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
              ),
        ),
      ],
    );
  }

  Widget _buildTrendIndicator(BuildContext context, double diff) {
    final isPositive = diff > 0;
    final isGood = _upIsGood ? isPositive : !isPositive;
    final trendColor = isGood ? AppColors.green : AppColors.red;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive ? LucideIcons.trendingUp : LucideIcons.trendingDown,
          size: 20,
          color: trendColor,
        ),
        const SizedBox(width: 4),
        Text(
          '${isPositive ? '+' : ''}${diff.toStringAsFixed(1)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: trendColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildChart(List<TrackerEntry> entries) {
    final spots = entries
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.value))
        .toList();

    final values = entries.map((e) => e.value).toList();
    final minVal = values.reduce(min);
    final maxVal = values.reduce(max);
    final padding = (maxVal - minVal) * 0.15;
    final minY = minVal - padding;
    final maxY = maxVal + padding;

    return SizedBox(
      height: 120,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (index, meta) {
                  final i = index.toInt();
                  if (i < 0 || i >= entries.length) {
                    return const SizedBox.shrink();
                  }
                  if (i == 0 || i == entries.length - 1) {
                    return Text(
                      DateFormat('dd/MM').format(entries[i].date),
                      style: TextStyle(
                          color: AppColors.textTertiary, fontSize: 10),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minY: minY,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: AppColors.blue,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: index == spots.length - 1 ? 4 : 2.5,
                    color: AppColors.blue,
                    strokeWidth: 0,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.blue.withValues(alpha: 0.08),
              ),
            ),
          ],
          lineTouchData: const LineTouchData(enabled: false),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Column(
          children: [
            Icon(LucideIcons.lineChart,
                color: AppColors.textTertiary, size: 32),
            const SizedBox(height: 8),
            Text(
              'Aucune donnée enregistrée',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddEntrySheet(
      BuildContext context, List<TrackerEntry> entries) async {
    final result = await showModalBottomSheet<TrackerEntry>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _AddTrackerEntrySheet(
        unit: _unit,
        lastValue: entries.isNotEmpty ? entries.last.value : null,
      ),
    );

    if (result != null) {
      final updatedEntries = [...entries, result]
        ..sort((a, b) => a.date.compareTo(b.date));
      onChanged(_serializeEntries(updatedEntries));
    }
  }
}

class _AddTrackerEntrySheet extends StatefulWidget {
  final String unit;
  final double? lastValue;

  const _AddTrackerEntrySheet({required this.unit, this.lastValue});

  @override
  State<_AddTrackerEntrySheet> createState() => _AddTrackerEntrySheetState();
}

class _AddTrackerEntrySheetState extends State<_AddTrackerEntrySheet> {
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
