using Core.Source.Models.Dtos;

namespace Core.Source.Hubs;

public interface ICategoryHubClient
{
    Task CategoryCreated(CategoryDto category);
    Task CategoryUpdated(CategoryDto category);
    Task CategoryDeleted(CategoryDto category);
    Task FullSyncCategories(List<CategoryDto> categories);
}
