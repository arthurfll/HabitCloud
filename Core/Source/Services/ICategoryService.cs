using Core.Source.Models.Dtos;

namespace Core.Source.Services;

public interface ICategoryService
{
    Task<PagedResult<CategoryDto>> GetPagedAsync(string userId, int page, int pageSize);
    Task<List<CategoryDto>> GetAllAsync(string userId);
    Task<CategoryResult> CreateAsync(string userId, string name, string icon, string color);
    Task<CategoryResult> UpdateNameAsync(string userId, int categoryId, string name);
    Task<CategoryResult> UpdateIconAsync(string userId, int categoryId, string icon);
    Task<CategoryResult> UpdateColorAsync(string userId, int categoryId, string color);
    Task<CategoryResult> DeleteAsync(string userId, int categoryId);
}
