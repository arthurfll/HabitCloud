import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/db/app_database.dart';
import '../../core/db/habit_repository.dart';
import '../../core/db/habit_schedule.dart';
import '../../core/models/habit_entry_model.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/color_utils.dart';

class HabitDetailScreen extends StatefulWidget {
  final int habitId;

  const HabitDetailScreen({super.key, required this.habitId});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  late DateTime _month;
  Map<DateTime, String> _statusByDay = {};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final repo = AppScope.of(context).habitRepository;
    final start = DateTime(_month.year, _month.month, 1);
    final end = DateTime(_month.year, _month.month + 1, 0);
    final entries = await repo.getEntriesInRange(widget.habitId, start, end);
    if (!mounted) return;
    setState(() {
      _statusByDay = {for (final e in entries) DateTime(e.date.year, e.date.month, e.date.day): e.status};
    });
  }

  void _changeMonth(int delta) {
    setState(() => _month = DateTime(_month.year, _month.month + delta));
    _loadEntries();
  }

  Future<void> _toggleDay(HabitsTableData habit, DateTime day) async {
    if (!isHabitDue(habit, day)) return;
    await AppScope.of(context).habitRepository.toggleEntry(habit.id, day);
    await _loadEntries();
  }

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.of(context).habitRepository;

    return StreamBuilder<HabitWithCategory?>(
      stream: repo.watchById(widget.habitId),
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
        }

        final color = hexToColor(data.category.color);
        final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
        final firstWeekday = DateTime(_month.year, _month.month, 1).weekday % 7; // 0=Sunday

        return Scaffold(
          appBar: AppBar(title: Text(data.habit.name)),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => _changeMonth(-1)),
                    Text(
                      '${_month.month.toString().padLeft(2, '0')}/${_month.year}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => _changeMonth(1)),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
                    itemCount: daysInMonth + firstWeekday,
                    itemBuilder: (context, index) {
                      if (index < firstWeekday) return const SizedBox.shrink();
                      final day = DateTime(_month.year, _month.month, index - firstWeekday + 1);
                      final due = isHabitDue(data.habit, day);
                      final status = _statusByDay[day] ?? HabitEntryStatus.none;

                      Color bg = Colors.transparent;
                      Color fg = due ? Colors.black87 : Colors.black26;
                      if (status == HabitEntryStatus.done) {
                        bg = AppColors.primaryBlue;
                        fg = Colors.white;
                      } else if (status == HabitEntryStatus.notDone) {
                        bg = Colors.red.shade100;
                      }

                      return GestureDetector(
                        onTap: due ? () => _toggleDay(data.habit, day) : null,
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: bg,
                            shape: BoxShape.circle,
                            border: due ? Border.all(color: color, width: 1.5) : null,
                          ),
                          alignment: Alignment.center,
                          child: Text('${day.day}', style: TextStyle(color: fg)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
