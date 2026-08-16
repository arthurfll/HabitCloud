using Core.Source.Data;
using Core.Source.Models;
using Microsoft.EntityFrameworkCore;

namespace Core.Source.Repositories;

public class CategoryRepository : ICategoryRepository
{
    private readonly AppDbContext _context;

    public CategoryRepository(AppDbContext context)
    {
        _context = context;
    }

    public Task<Category?> GetByIdAsync(int id) =>
        _context.Categories.FirstOrDefaultAsync(c => c.Id == id);

    public Task<List<Category>> GetAllByUserAsync(string userId) =>
        _context.Categories
            .Where(c => c.UserId == userId)
            .OrderBy(c => c.Name)
            .ToListAsync();

    public Task<List<Category>> GetPageByUserAsync(string userId, int page, int pageSize) =>
        _context.Categories
            .Where(c => c.UserId == userId)
            .OrderByDescending(c => c.CreatedAt)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

    public Task<int> CountByUserAsync(string userId) =>
        _context.Categories.CountAsync(c => c.UserId == userId);

    public async Task AddAsync(Category category) =>
        await _context.Categories.AddAsync(category);

    public void Update(Category category) =>
        _context.Categories.Update(category);

    public Task<int> SaveChangesAsync() => _context.SaveChangesAsync();
}
