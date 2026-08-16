namespace Core.Source.Models;

public static class HabitScheduleCalculator
{
    public static bool IsDue(Habito habit, DateOnly date) => habit.FrequencyType switch
    {
        HabitFrequencyType.EveryNDays => IsDueEveryNDays(habit, date),
        HabitFrequencyType.DayOfMonth => IsDueDayOfMonth(habit, date),
        HabitFrequencyType.DayOfWeek => date.DayOfWeek == habit.DayOfWeek,
        _ => false,
    };

    private static bool IsDueEveryNDays(Habito habit, DateOnly date)
    {
        var interval = habit.IntervalDays ?? 0;
        if (interval <= 0)
        {
            return true;
        }

        if (date < habit.StartDate)
        {
            return false;
        }

        var daysSinceStart = date.DayNumber - habit.StartDate.DayNumber;
        return daysSinceStart % interval == 0;
    }

    private static bool IsDueDayOfMonth(Habito habit, DateOnly date)
    {
        var day = habit.DayOfMonth ?? 1;
        var daysInMonth = DateTime.DaysInMonth(date.Year, date.Month);
        var effectiveDay = Math.Min(day, daysInMonth);
        return date.Day == effectiveDay;
    }
}
