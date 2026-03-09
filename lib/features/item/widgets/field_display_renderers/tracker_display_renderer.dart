import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/field_definition.dart';
import '../field_renderers/tracker_utils.dart';

/// Display for tracker fields (last value + trend + chart + add button).
class TrackerDisplayRenderer extends StatelessWidget {
  final FieldDefinition definition;
  final dynamic value;
  final Color collectionColor;

  /// Called when a new entry is added. If null, the add button is hidden.
  final ValueChanged<dynamic>? onChanged;

  const TrackerDisplayRenderer({
    super.key,
    required this.definition,
    required this.value,
    required this.collectionColor,
    this.onChanged,
  });

  String get _unit => definition.options['unit'] as String? ?? '';

  bool get _upIsGood =>
      (definition.options['improvementDirection'] as String? ?? 'up') == 'up';

  @override
  Widget build(BuildContext context) {
    final entries = parseTrackerEntries(value);
    final lastEntry = entries.isNotEmpty ? entries.last : null;
    final previousEntry =
        entries.length >= 2 ? entries[entries.length - 2] : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, entries),
        if (lastEntry != null) ...[
          const SizedBox(height: 8),
          _buildLastValue(context, lastEntry, previousEntry),
        ],
        if (entries.length >= 2) ...[
          const SizedBox(height: 12),
          _buildChart(entries),
        ],
        if (entries.isEmpty) _buildEmptyState(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, List<TrackerEntry> entries) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          definition.name,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.appTextSecondary,
              ),
        ),
        if (onChanged != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (entries.isNotEmpty)
                GestureDetector(
                  onTap: () => _showHistorySheet(context, entries),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: context.appBorder.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.list,
                            size: 16, color: context.appTextSecondary),
                        const SizedBox(width: 4),
                        Text(
                          'Historique',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: context.appTextSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _showAddEntrySheet(context, entries),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: collectionColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.plus, size: 16, color: collectionColor),
                      const SizedBox(width: 4),
                      Text(
                        'Ajouter',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: collectionColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
                color: context.appTextPrimary,
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
                color: context.appTextTertiary,
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
                interval: max(1, entries.length - 1).toDouble(),
                getTitlesWidget: (index, meta) {
                  final i = index.round();
                  if ((index - i).abs() > 0.01) {
                    return const SizedBox.shrink();
                  }
                  if (i < 0 || i >= entries.length) {
                    return const SizedBox.shrink();
                  }
                  return Builder(
                    builder: (context) => Text(
                      DateFormat('dd/MM').format(entries[i].date),
                      style: TextStyle(
                          color: context.appTextTertiary, fontSize: 10),
                    ),
                  );
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
              color: collectionColor,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: index == spots.length - 1 ? 4 : 2.5,
                    color: collectionColor,
                    strokeWidth: 0,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: collectionColor.withValues(alpha: 0.08),
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
                color: context.appTextTertiary, size: 32),
            const SizedBox(height: 8),
            Text(
              'Aucune donnée enregistrée',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.appTextTertiary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddEntrySheet(
      BuildContext context, List<TrackerEntry> entries) async {
    final result = await showAddTrackerEntrySheet(
      context,
      unit: _unit,
      lastValue: entries.isNotEmpty ? entries.last.value : null,
    );

    if (result != null && onChanged != null) {
      final updatedEntries = [...entries, result]
        ..sort((a, b) => a.date.compareTo(b.date));
      onChanged!(serializeTrackerEntries(updatedEntries));
    }
  }

  Future<void> _showHistorySheet(
      BuildContext context, List<TrackerEntry> entries) async {
    final updatedEntries = await showTrackerHistorySheet(
      context,
      entries: entries,
      unit: _unit,
    );

    if (updatedEntries != null && onChanged != null) {
      onChanged!(serializeTrackerEntries(updatedEntries));
    }
  }
}
