using Core.Source.Models;

namespace Core.Source.Repositories;

public interface IHabitEntryRepository
{
    Task<HabitEntry?> GetAsync(int habitId, DateOnly date);
    Task<List<HabitEntry>> GetRangeAsync(int habitId, DateOnly start, DateOnly end);
    Task<List<HabitEntry>> GetForHabitsOnDateAsync(IReadOnlyCollection<int> habitIds, DateOnly date);
    Task AddAsync(HabitEntry entry);
    void Update(HabitEntry entry);
    void Remove(HabitEntry entry);
    Task<int> SaveChangesAsync();
}
