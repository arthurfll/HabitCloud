using Core.Source.Hubs;
using Core.Source.Models;
using Core.Source.Models.Dtos;
using Core.Source.Repositories;
using Microsoft.AspNetCore.SignalR;

namespace Core.Source.Services;

public class CategoryService : ICategoryService
{
    private readonly ICategoryRepository _repository;
    private readonly IHubContext<CategoryHub, ICategoryHubClient> _hubContext;

    public CategoryService(ICategoryRepository repository, IHubContext<CategoryHub, ICategoryHubClient> hubContext)
    {
        _repository = repository;
        _hubContext = hubContext;
    }

    public async Task<PagedResult<CategoryDto>> GetPagedAsync(string userId, int page, int pageSize)
    {
        if (page < 1) page = 1;

        var totalCount = await _repository.CountByUserAsync(userId);
        var items = await _repository.GetPageByUserAsync(userId, page, pageSize);

        return new PagedResult<CategoryDto>
        {
            Items = items.Select(ToDto).ToList(),
            Page = page,
            PageSize = pageSize,
            TotalCount = totalCount,
        };
    }

    public async Task<List<CategoryDto>> GetAllAsync(string userId)
    {
        var categories = await _repository.GetAllByUserAsync(userId);
        return categories.Select(ToDto).ToList();
    }

    public async Task<CategoryResult> CreateAsync(string userId, string name, string icon, string color)
    {
        name = name?.Trim() ?? string.Empty;

        if (string.IsNullOrWhiteSpace(name) || name.Length > 50)
            return CategoryResult.Fail(CategoryOperationError.InvalidName);

        if (!CategoryOptions.IsValidIcon(icon))
            return CategoryResult.Fail(CategoryOperationError.InvalidIcon);

        if (!CategoryOptions.IsValidColor(color))
            return CategoryResult.Fail(CategoryOperationError.InvalidColor);

        var currentCount = await _repository.CountByUserAsync(userId);
        if (currentCount >= CategoryOptions.MaxCategoriesPerUser)
            return CategoryResult.Fail(CategoryOperationError.LimitReached);

        var now = DateTime.UtcNow;
        var category = new Category
        {
            Name = name,
            Icon = icon,
            Color = color,
            UserId = userId,
            CreatedAt = now,
            UpdatedAt = now,
        };

        await _repository.AddAsync(category);
        await _repository.SaveChangesAsync();

        var dto = ToDto(category);
        await _hubContext.Clients.User(userId).CategoryCreated(dto);

        return CategoryResult.Ok(dto);
    }

    public async Task<CategoryResult> UpdateNameAsync(string userId, int categoryId, string name)
    {
        name = name?.Trim() ?? string.Empty;

        if (string.IsNullOrWhiteSpace(name) || name.Length > 50)
            return CategoryResult.Fail(CategoryOperationError.InvalidName);

        var category = await _repository.GetByIdAsync(categoryId);
        var ownershipError = ValidateOwnership(category, userId);
        if (ownershipError is not null)
            return CategoryResult.Fail(ownershipError.Value);

        category!.Name = name;
        return await SaveAndBroadcastAsync(category, userId);
    }

    public async Task<CategoryResult> UpdateIconAsync(string userId, int categoryId, string icon)
    {
        if (!CategoryOptions.IsValidIcon(icon))
            return CategoryResult.Fail(CategoryOperationError.InvalidIcon);

        var category = await _repository.GetByIdAsync(categoryId);
        var ownershipError = ValidateOwnership(category, userId);
        if (ownershipError is not null)
            return CategoryResult.Fail(ownershipError.Value);

        category!.Icon = icon;
        return await SaveAndBroadcastAsync(category, userId);
    }

    public async Task<CategoryResult> UpdateColorAsync(string userId, int categoryId, string color)
    {
        if (!CategoryOptions.IsValidColor(color))
            return CategoryResult.Fail(CategoryOperationError.InvalidColor);

        var category = await _repository.GetByIdAsync(categoryId);
        var ownershipError = ValidateOwnership(category, userId);
        if (ownershipError is not null)
            return CategoryResult.Fail(ownershipError.Value);

        category!.Color = color;
        return await SaveAndBroadcastAsync(category, userId);
    }

    public async Task<CategoryResult> DeleteAsync(string userId, int categoryId)
    {
        var category = await _repository.GetByIdAsync(categoryId);
        var ownershipError = ValidateOwnership(category, userId);
        if (ownershipError is not null)
            return CategoryResult.Fail(ownershipError.Value);

        category!.IsDeleted = true;
        category.UpdatedAt = DateTime.UtcNow;
        _repository.Update(category);
        await _repository.SaveChangesAsync();

        var dto = ToDto(category);
        await _hubContext.Clients.User(userId).CategoryDeleted(dto);

        return CategoryResult.Ok(dto);
    }

    private static CategoryOperationError? ValidateOwnership(Category? category, string userId)
    {
        if (category is null || category.IsDeleted)
            return CategoryOperationError.NotFound;

        if (!string.Equals(category.UserId, userId, StringComparison.Ordinal))
            return CategoryOperationError.Forbidden;

        return null;
    }

    private async Task<CategoryResult> SaveAndBroadcastAsync(Category category, string userId)
    {
        category.UpdatedAt = DateTime.UtcNow;
        _repository.Update(category);
        await _repository.SaveChangesAsync();

        var dto = ToDto(category);
        await _hubContext.Clients.User(userId).CategoryUpdated(dto);

        return CategoryResult.Ok(dto);
    }

    private static CategoryDto ToDto(Category category) => new()
    {
        Id = category.Id,
        Name = category.Name,
        Icon = category.Icon,
        Color = category.Color,
        UpdatedAt = category.UpdatedAt,
        IsDeleted = category.IsDeleted,
    };
}
