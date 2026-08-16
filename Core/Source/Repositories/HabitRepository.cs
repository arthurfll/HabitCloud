using Core.Source.Data;
using Core.Source.Models;
using Microsoft.EntityFrameworkCore;

namespace Core.Source.Repositories;

public class HabitRepository : IHabitRepository
{
    private readonly AppDbContext _context;

    public HabitRepository(AppDbContext context)
    {
        _context = context;
    }

    public Task<Habito?> GetByIdAsync(int id) =>
        _context.Habitos.Include(h => h.Category).FirstOrDefaultAsync(h => h.Id == id);

    public Task<List<Habito>> GetAllByUserAsync(string userId) =>
        _context.Habitos
            .Include(h => h.Category)
            .Where(h => h.UserId == userId)
            .OrderBy(h => h.Name)
            .ToListAsync();

    public Task<int> CountByUserAsync(string userId) =>
        _context.Habitos.CountAsync(h => h.UserId == userId);

    public async Task AddAsync(Habito habit) =>
        await _context.Habitos.AddAsync(habit);

    public void Update(Habito habit) =>
        _context.Habitos.Update(habit);

    public Task<int> SaveChangesAsync() => _context.SaveChangesAsync();
}
