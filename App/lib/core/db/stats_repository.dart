import 'habit_repository.dart';
import 'habit_schedule.dart';

class StatsDailyPoint {
  final DateTime date;
  final int totalDue;
  final int totalDone;

  const StatsDailyPoint({required this.date, required this.totalDue, required this.totalDone});

  double get percentDone => totalDue == 0 ? 0 : totalDone * 100 / totalDue;
}

class HabitStatsSummary {
  final HabitWithCategory habit;
  final int daysDue;
  final int daysDone;

  const HabitStatsSummary({required this.habit, required this.daysDue, required this.daysDone});

  double get percentDone => daysDue == 0 ? 0 : daysDone * 100 / daysDue;
}

class HabitStats {
  final List<StatsDailyPoint> dailySeries;
  final List<HabitStatsSummary> perHabit;

  const HabitStats({required this.dailySeries, required this.perHabit});
}

/// Mirrors HabitService.GetStatsAsync (Core/Source/Services/HabitService.cs) so the numbers shown
/// here match the web app for the same period once synced — same rules: a day with no habit due
/// is a gap (not 0%), and a habit with zero due days in the period is left out of the per-habit list.
class StatsRepository {
  final HabitRepository _habitRepository;

  StatsRepository(this._habitRepository);

  Future<HabitStats> getStats(int days) async {
    final today = DateTime.now();
    final end = DateTime(today.year, today.month, today.day);
    final start = end.subtract(Duration(days: days - 1));

    final habits = await _habitRepository.getAll();
    final entries = await _habitRepository.getEntriesForAllHabitsInRange(start, end);

    final entriesByHabitAndDate = <String, String>{};
    for (final e in entries) {
      final d = DateTime(e.date.year, e.date.month, e.date.day);
      entriesByHabitAndDate['${e.habitId}_$d'] = e.status;
    }

    final dailySeries = <StatsDailyPoint>[];
    for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
      final dueHabits = habits.where((h) => isHabitDue(h.habit, d)).toList();
      if (dueHabits.isEmpty) continue;

      final doneCount = dueHabits.where((h) => entriesByHabitAndDate['${h.habit.id}_$d'] == 'Done').length;

      dailySeries.add(StatsDailyPoint(date: d, totalDue: dueHabits.length, totalDone: doneCount));
    }

    final perHabit = <HabitStatsSummary>[];
    for (final h in habits) {
      var daysDue = 0;
      var daysDone = 0;
      for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
        if (!isHabitDue(h.habit, d)) continue;
        daysDue++;
        if (entriesByHabitAndDate['${h.habit.id}_$d'] == 'Done') daysDone++;
      }
      if (daysDue == 0) continue;
      perHabit.add(HabitStatsSummary(habit: h, daysDue: daysDue, daysDone: daysDone));
    }

    return HabitStats(dailySeries: dailySeries, perHabit: perHabit);
  }
}
