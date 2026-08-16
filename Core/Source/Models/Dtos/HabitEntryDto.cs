namespace Core.Source.Models.Dtos;

/// <summary>Sync/backup representation of a HabitEntry (distinct from HabitCalendarDayDto, which is calendar-rendering only).</summary>
public class HabitEntryDto
{
    public int Id { get; set; }
    public int HabitId { get; set; }
    public string Date { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public DateTime UpdatedAt { get; set; }
    public bool IsDeleted { get; set; }
}
