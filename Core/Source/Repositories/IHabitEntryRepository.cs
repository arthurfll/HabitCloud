using Core.Source.Models;

namespace Core.Source.Repositories;

public interface IHabitEntryRepository
{
    Task<HabitEntry?> GetByIdAsync(int id);
    Task<HabitEntry?> GetAsync(int habitId, DateOnly date);
    Task<List<HabitEntry>> GetRangeAsync(int habitId, DateOnly start, DateOnly end);
    Task<List<HabitEntry>> GetForUserInRangeAsync(string userId, DateOnly start, DateOnly end);
    Task<List<HabitEntry>> GetForHabitsOnDateAsync(IReadOnlyCollection<int> habitIds, DateOnly date);
    Task<List<HabitEntry>> GetChangedSinceForUserAsync(string userId, DateTime since);
    Task AddAsync(HabitEntry entry);
    void Update(HabitEntry entry);
    Task<int> SaveChangesAsync();
}
