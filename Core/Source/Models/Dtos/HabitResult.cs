namespace Core.Source.Models.Dtos;

public enum HabitOperationError
{
    None,
    NotFound,
    Forbidden,
    LimitReached,
    InvalidName,
    InvalidCategory,
    InvalidFrequency,
    NotDue,
}

public class HabitResult
{
    public bool Success { get; set; }
    public HabitOperationError Error { get; set; } = HabitOperationError.None;
    public HabitDto? Habit { get; set; }

    public static HabitResult Ok(HabitDto habit) => new() { Success = true, Habit = habit };
    public static HabitResult Fail(HabitOperationError error) => new() { Success = false, Error = error };
}

public class HabitEntryResult
{
    public bool Success { get; set; }
    public HabitOperationError Error { get; set; } = HabitOperationError.None;
    public HabitCalendarDayDto? Entry { get; set; }

    public static HabitEntryResult Ok(HabitCalendarDayDto entry) => new() { Success = true, Entry = entry };
    public static HabitEntryResult Fail(HabitOperationError error) => new() { Success = false, Error = error };
}
