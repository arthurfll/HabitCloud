using Core.Source.Models;

namespace Core.Source.Repositories;

public interface ICategoryRepository
{
    Task<Category?> GetByIdAsync(int id);
    Task<List<Category>> GetAllByUserAsync(string userId);
    Task<List<Category>> GetPageByUserAsync(string userId, int page, int pageSize);
    Task<List<Category>> GetChangedSinceAsync(string userId, DateTime since);
    Task<int> CountByUserAsync(string userId);
    Task AddAsync(Category category);
    void Update(Category category);
    Task<int> SaveChangesAsync();
}
