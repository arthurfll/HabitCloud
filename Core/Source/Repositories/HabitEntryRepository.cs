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

    public Task<HabitEntry?> GetByIdAsync(int id) =>
        _context.HabitEntries.FirstOrDefaultAsync(e => e.Id == id);

    public Task<HabitEntry?> GetAsync(int habitId, DateOnly date) =>
        _context.HabitEntries.FirstOrDefaultAsync(e => e.HabitId == habitId && e.Date == date);

    public Task<List<HabitEntry>> GetRangeAsync(int habitId, DateOnly start, DateOnly end) =>
        _context.HabitEntries
            .Where(e => e.HabitId == habitId && e.Date >= start && e.Date <= end && !e.IsDeleted)
            .ToListAsync();

    public Task<List<HabitEntry>> GetForUserInRangeAsync(string userId, DateOnly start, DateOnly end) =>
        _context.HabitEntries
            .Where(e => e.Habit!.UserId == userId && e.Date >= start && e.Date <= end && !e.IsDeleted)
            .ToListAsync();

    public Task<List<HabitEntry>> GetForHabitsOnDateAsync(IReadOnlyCollection<int> habitIds, DateOnly date) =>
        _context.HabitEntries
            .Where(e => habitIds.Contains(e.HabitId) && e.Date == date && !e.IsDeleted)
            .ToListAsync();

    public Task<List<HabitEntry>> GetChangedSinceForUserAsync(string userId, DateTime since) =>
        _context.HabitEntries
            .Where(e => e.Habit!.UserId == userId && e.UpdatedAt > since)
            .ToListAsync();

    public async Task AddAsync(HabitEntry entry) =>
        await _context.HabitEntries.AddAsync(entry);

    public void Update(HabitEntry entry) =>
        _context.HabitEntries.Update(entry);

    public Task<int> SaveChangesAsync() => _context.SaveChangesAsync();
}
