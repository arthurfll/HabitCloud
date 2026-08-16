import 'app_database.dart';

/// Dart port of Core's HabitScheduleCalculator (Core/Source/Models/HabitScheduleCalculator.cs) —
/// kept behaviorally identical so a habit shows as due on the same days offline as it would online.
bool isHabitDue(HabitsTableData habit, DateTime date) {
  switch (habit.frequencyType) {
    case 1: // EveryNDays
      return _isDueEveryNDays(habit, date);
    case 2: // DayOfMonth
      return _isDueDayOfMonth(habit, date);
    case 3: // DayOfWeek
      return _dotNetDayOfWeek(date) == habit.dayOfWeek;
    default:
      return false;
  }
}

bool _isDueEveryNDays(HabitsTableData habit, DateTime date) {
  final interval = habit.intervalDays ?? 0;
  if (interval <= 0) return true;

  final start = _dateOnly(habit.startDate);
  final target = _dateOnly(date);
  if (target.isBefore(start)) return false;

  final daysSinceStart = target.difference(start).inDays;
  return daysSinceStart % interval == 0;
}

bool _isDueDayOfMonth(HabitsTableData habit, DateTime date) {
  final day = habit.dayOfMonth ?? 1;
  final daysInMonth = DateTime(date.year, date.month + 1, 0).day;
  final effectiveDay = day < daysInMonth ? day : daysInMonth;
  return date.day == effectiveDay;
}

DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

/// Dart's DateTime.weekday is Monday=1..Sunday=7; Core stores .NET's DayOfWeek (Sunday=0..Saturday=6).
int _dotNetDayOfWeek(DateTime date) => date.weekday % 7;
