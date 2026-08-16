using Core.Source.Models;

namespace Core.Source.Repositories;

public interface IHabitRepository
{
    Task<Habito?> GetByIdAsync(int id);
    Task<List<Habito>> GetAllByUserAsync(string userId);
    Task<int> CountByUserAsync(string userId);
    Task AddAsync(Habito habit);
    void Update(Habito habit);
    Task<int> SaveChangesAsync();
}
