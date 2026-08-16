namespace Core.Source.Models.Dtos;

public class HabitCalendarDayDto
{
    public int HabitId { get; set; }
    public string Date { get; set; } = string.Empty;
    public bool Due { get; set; }
    public string Status { get; set; } = "None";
}

public class HabitCalendarDto
{
    public int HabitId { get; set; }
    public int Year { get; set; }
    public int Month { get; set; }
    public List<HabitCalendarDayDto> Days { get; set; } = new();
}
