using Core.Source.Data;
using Core.Source.Models;
using Microsoft.EntityFrameworkCore;

namespace Core.Source.Repositories;

public class HabitEntryRepository : IHabitEntryRepository
{
    private readonly AppDbContext _context;

    public HabitEntryRepository(AppDbContext context)
    {
        _context = context;
    }

    public Task<HabitEntry?> GetAsync(int habitId, DateOnly date) =>
        _context.HabitEntries.FirstOrDefaultAsync(e => e.HabitId == habitId && e.Date == date);

    public Task<List<HabitEntry>> GetRangeAsync(int habitId, DateOnly start, DateOnly end) =>
        _context.HabitEntries
            .Where(e => e.HabitId == habitId && e.Date >= start && e.Date <= end)
            .ToListAsync();

    public Task<List<HabitEntry>> GetForHabitsOnDateAsync(IReadOnlyCollection<int> habitIds, DateOnly date) =>
        _context.HabitEntries
            .Where(e => habitIds.Contains(e.HabitId) && e.Date == date)
            .ToListAsync();

    public async Task AddAsync(HabitEntry entry) =>
        await _context.HabitEntries.AddAsync(entry);

    public void Update(HabitEntry entry) =>
        _context.HabitEntries.Update(entry);

    public void Remove(HabitEntry entry) =>
        _context.HabitEntries.Remove(entry);

    public Task<int> SaveChangesAsync() => _context.SaveChangesAsync();
}
