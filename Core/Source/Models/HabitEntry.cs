namespace Core.Source.Models;

public class HabitEntry
{
    public int Id { get; set; }

    public int HabitId { get; set; }

    public Habito? Habit { get; set; }

    public DateOnly Date { get; set; }

    public HabitEntryStatus Status { get; set; }
}
