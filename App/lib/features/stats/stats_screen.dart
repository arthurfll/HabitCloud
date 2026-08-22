import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/db/stats_repository.dart';
import '../../core/icons/bootstrap_icon_map.dart';
import '../../core/utils/color_utils.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _selectedDays = 30;

  String _dayLabel(DateTime date) => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';

  Widget _buildChart(List<StatsDailyPoint> dailySeries) {
    if (dailySeries.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Sem dados suficientes nesse período.')),
      );
    }

    final spots = [
      for (var i = 0; i < dailySeries.length; i++) FlSpot(i.toDouble(), dailySeries[i].percentDone),
    ];

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 100,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) => touchedSpots.map((s) {
                final point = dailySeries[s.x.toInt()];
                return LineTooltipItem('${_dayLabel(point.date)}\n${point.percentDone.round()}%', const TextStyle());
              }).toList(),
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                interval: 25,
                getTitlesWidget: (value, meta) => Text('${value.toInt()}%', style: const TextStyle(fontSize: 10)),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                interval: (dailySeries.length / 5).clamp(1, dailySeries.length).toDouble(),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= dailySeries.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(_dayLabel(dailySeries[index].date), style: const TextStyle(fontSize: 10)),
                  );
                },
              ),
            ),
          ),
          gridData: const FlGridData(drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerHabitList(List<HabitStatsSummary> perHabit) {
    if (perHabit.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: Text('Nenhum hábito com dias devidos nesse período.')),
      );
    }

    return Column(
      children: perHabit.map((s) {
        final color = hexToColor(s.habit.category.color);
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(iconFor(s.habit.category.icon), color: color),
            ),
            title: Text(s.habit.habit.name),
            subtitle: Text('${s.daysDone}/${s.daysDue} dias'),
            trailing: Text(
              '${s.percentDone.round()}%',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statsRepository = AppScope.of(context).statsRepository;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 7, label: Text('7 dias')),
              ButtonSegment(value: 30, label: Text('30 dias')),
              ButtonSegment(value: 90, label: Text('90 dias')),
            ],
            selected: {_selectedDays},
            onSelectionChanged: (selection) => setState(() => _selectedDays = selection.first),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<HabitStats>(
              future: statsRepository.getStats(_selectedDays),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final stats = snapshot.data!;
                return ListView(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                        child: _buildChart(stats.dailySeries),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Conclusão por hábito', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    _buildPerHabitList(stats.perHabit),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
