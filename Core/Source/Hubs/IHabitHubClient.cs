using Core.Source.Models.Dtos;

namespace Core.Source.Hubs;

public interface IHabitHubClient
{
    Task HabitCreated(HabitDto habit);
    Task HabitUpdated(HabitDto habit);
    Task HabitDeleted(HabitDto habit);
    Task HabitEntryUpdated(HabitCalendarDayDto entry);
    Task FullSyncHabits(List<HabitDto> habits);
}
