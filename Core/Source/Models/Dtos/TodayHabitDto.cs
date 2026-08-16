namespace Core.Source.Models.Dtos;

public class TodayHabitDto
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string CategoryIcon { get; set; } = string.Empty;
    public string CategoryColor { get; set; } = string.Empty;
    public string Status { get; set; } = "None";
}
