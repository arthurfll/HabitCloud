namespace Core.Source.Models.Dtos;

public class StatsDailyPointDto
{
    public string Date { get; set; } = string.Empty;
    public int TotalDue { get; set; }
    public int TotalDone { get; set; }
    public double PercentDone { get; set; }
}

public class HabitStatsSummaryDto
{
    public int HabitId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string CategoryIcon { get; set; } = string.Empty;
    public string CategoryColor { get; set; } = string.Empty;
    public int DaysDue { get; set; }
    public int DaysDone { get; set; }
    public double PercentDone { get; set; }
}

public class HabitStatsDto
{
    public int Days { get; set; }
    public List<StatsDailyPointDto> DailySeries { get; set; } = new();
    public List<HabitStatsSummaryDto> PerHabit { get; set; } = new();
}
