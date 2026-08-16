using Core.Source.Models;
using Core.Source.Models.Dtos;
using Core.Source.Models.Dtos.Sync;
using Core.Source.Repositories;
using Microsoft.Extensions.Logging;

namespace Core.Source.Services;

/// <summary>
/// Applies the mobile app's offline changes and returns everything the server considers newer,
/// resolving conflicts by "last edit wins" (highest UpdatedAt), the primary database being the
/// tie-breaker. Used by the app's ~2am background backup job.
/// </summary>
public class SyncService : ISyncService
{
    private readonly ICategoryRepository _categoryRepository;
    private readonly IHabitRepository _habitRepository;
    private readonly IHabitEntryRepository _entryRepository;
    private readonly ILogger<SyncService> _logger;

    public SyncService(
        ICategoryRepository categoryRepository,
        IHabitRepository habitRepository,
        IHabitEntryRepository entryRepository,
        ILogger<SyncService> logger)
    {
        _categoryRepository = categoryRepository;
        _habitRepository = habitRepository;
        _entryRepository = entryRepository;
        _logger = logger;
    }

    public async Task<SyncResponseDto> SyncAsync(string userId, SyncRequestDto request)
    {
        var since = request.LastSyncedAt ?? DateTime.MinValue;
        var now = DateTime.UtcNow;

        var categoryTempIdMap = new Dictionary<string, int>();
        var categoryMappings = new List<IdMappingDto>();
        var conflictWinnerCategories = new List<Category>();

        foreach (var item in request.Categories)
        {
            await ApplyCategoryAsync(userId, item, categoryTempIdMap, categoryMappings, conflictWinnerCategories);
        }
        await _categoryRepository.SaveChangesAsync();

        var habitTempIdMap = new Dictionary<string, int>();
        var habitMappings = new List<IdMappingDto>();
        var conflictWinnerHabits = new List<Habito>();

        foreach (var item in request.Habits)
        {
            await ApplyHabitAsync(userId, item, categoryTempIdMap, habitTempIdMap, habitMappings, conflictWinnerHabits);
        }
        await _habitRepository.SaveChangesAsync();

        var entryMappings = new List<IdMappingDto>();
        var conflictWinnerEntries = new List<HabitEntry>();

        foreach (var item in request.HabitEntries)
        {
            await ApplyHabitEntryAsync(item, habitTempIdMap, entryMappings, conflictWinnerEntries);
        }
        await _entryRepository.SaveChangesAsync();

        var changedCategories = await _categoryRepository.GetChangedSinceAsync(userId, since);
        var changedHabits = await _habitRepository.GetChangedSinceAsync(userId, since);
        var changedEntries = await _entryRepository.GetChangedSinceForUserAsync(userId, since);

        return new SyncResponseDto
        {
            SyncedAt = now,
            Categories = MergeById(changedCategories, conflictWinnerCategories, c => c.Id).Select(ToCategoryDto).ToList(),
            Habits = MergeById(changedHabits, conflictWinnerHabits, h => h.Id).Select(ToHabitDto).ToList(),
            HabitEntries = MergeById(changedEntries, conflictWinnerEntries, e => e.Id).Select(ToHabitEntryDto).ToList(),
            CategoryIdMappings = categoryMappings,
            HabitIdMappings = habitMappings,
            HabitEntryIdMappings = entryMappings,
        };
    }

    private async Task ApplyCategoryAsync(
        string userId,
        CategorySyncItemDto item,
        Dictionary<string, int> tempIdMap,
        List<IdMappingDto> mappings,
        List<Category> conflictWinners)
    {
        if (!item.IsDeleted && (!CategoryOptions.IsValidIcon(item.Icon) || !CategoryOptions.IsValidColor(item.Color) || string.IsNullOrWhiteSpace(item.Name)))
        {
            _logger.LogWarning("Skipping invalid category in sync payload for user {UserId}", userId);
            return;
        }

        if (item.Id is int id)
        {
            var existing = await _categoryRepository.GetByIdAsync(id);
            if (existing is null || !string.Equals(existing.UserId, userId, StringComparison.Ordinal))
            {
                return;
            }

            if (item.UpdatedAt > existing.UpdatedAt)
            {
                existing.Name = item.Name;
                existing.Icon = item.Icon;
                existing.Color = item.Color;
                existing.IsDeleted = item.IsDeleted;
                existing.UpdatedAt = item.UpdatedAt;
                _categoryRepository.Update(existing);
            }
            else
            {
                conflictWinners.Add(existing);
            }

            return;
        }

        if (string.IsNullOrEmpty(item.ClientTempId))
        {
            return;
        }

        var category = new Category
        {
            Name = item.Name,
            Icon = item.Icon,
            Color = item.Color,
            UserId = userId,
            CreatedAt = item.UpdatedAt,
            UpdatedAt = item.UpdatedAt,
            IsDeleted = item.IsDeleted,
        };

        await _categoryRepository.AddAsync(category);
        await _categoryRepository.SaveChangesAsync();

        tempIdMap[item.ClientTempId] = category.Id;
        mappings.Add(new IdMappingDto { ClientTempId = item.ClientTempId, ServerId = category.Id });
    }

    private async Task ApplyHabitAsync(
        string userId,
        HabitSyncItemDto item,
        Dictionary<string, int> categoryTempIdMap,
        Dictionary<string, int> tempIdMap,
        List<IdMappingDto> mappings,
        List<Habito> conflictWinners)
    {
        int? categoryId = item.CategoryId;
        if (categoryId is null && item.CategoryClientTempId is not null)
        {
            categoryTempIdMap.TryGetValue(item.CategoryClientTempId, out var resolved);
            categoryId = resolved == 0 ? null : resolved;
        }

        if (!item.IsDeleted)
        {
            if (categoryId is null || string.IsNullOrWhiteSpace(item.Name))
            {
                _logger.LogWarning("Skipping invalid habit in sync payload for user {UserId}", userId);
                return;
            }

            if (HabitService.ValidateFrequency(item.FrequencyType, item.IntervalDays, item.DayOfMonth, item.DayOfWeek) is not null)
            {
                _logger.LogWarning("Skipping habit with invalid frequency in sync payload for user {UserId}", userId);
                return;
            }
        }

        if (item.Id is int id)
        {
            var existing = await _habitRepository.GetByIdAsync(id);
            if (existing is null || !string.Equals(existing.UserId, userId, StringComparison.Ordinal))
            {
                return;
            }

            if (item.UpdatedAt > existing.UpdatedAt)
            {
                existing.Name = item.Name;
                existing.CategoryId = categoryId ?? existing.CategoryId;
                existing.FrequencyType = item.FrequencyType;
                existing.IntervalDays = item.IntervalDays;
                existing.DayOfMonth = item.DayOfMonth;
                existing.DayOfWeek = item.DayOfWeek;
                existing.StartDate = item.StartDate;
                existing.IsDeleted = item.IsDeleted;
                existing.UpdatedAt = item.UpdatedAt;
                _habitRepository.Update(existing);
            }
            else
            {
                conflictWinners.Add(existing);
            }

            return;
        }

        if (string.IsNullOrEmpty(item.ClientTempId) || categoryId is null)
        {
            return;
        }

        var habit = new Habito
        {
            Name = item.Name,
            UserId = userId,
            CategoryId = categoryId.Value,
            FrequencyType = item.FrequencyType,
            IntervalDays = item.IntervalDays,
            DayOfMonth = item.DayOfMonth,
            DayOfWeek = item.DayOfWeek,
            StartDate = item.StartDate,
            CreatedAt = item.UpdatedAt,
            UpdatedAt = item.UpdatedAt,
            IsDeleted = item.IsDeleted,
        };

        await _habitRepository.AddAsync(habit);
        await _habitRepository.SaveChangesAsync();

        tempIdMap[item.ClientTempId] = habit.Id;
        mappings.Add(new IdMappingDto { ClientTempId = item.ClientTempId, ServerId = habit.Id });
    }

    private async Task ApplyHabitEntryAsync(
        HabitEntrySyncItemDto item,
        Dictionary<string, int> habitTempIdMap,
        List<IdMappingDto> mappings,
        List<HabitEntry> conflictWinners)
    {
        int? habitId = item.HabitId;
        if (habitId is null && item.HabitClientTempId is not null)
        {
            habitTempIdMap.TryGetValue(item.HabitClientTempId, out var resolved);
            habitId = resolved == 0 ? null : resolved;
        }

        if (habitId is null || !DateOnly.TryParse(item.Date, out var date) || !Enum.TryParse<HabitEntryStatus>(item.Status, out var status))
        {
            return;
        }

        if (item.Id is int id)
        {
            var existing = await _entryRepository.GetByIdAsync(id);
            if (existing is null || existing.HabitId != habitId)
            {
                return;
            }

            if (item.UpdatedAt > existing.UpdatedAt)
            {
                existing.Status = status;
                existing.IsDeleted = item.IsDeleted;
                existing.UpdatedAt = item.UpdatedAt;
                _entryRepository.Update(existing);
            }
            else
            {
                conflictWinners.Add(existing);
            }

            return;
        }

        if (string.IsNullOrEmpty(item.ClientTempId))
        {
            return;
        }

        var entry = new HabitEntry
        {
            HabitId = habitId.Value,
            Date = date,
            Status = status,
            CreatedAt = item.UpdatedAt,
            UpdatedAt = item.UpdatedAt,
            IsDeleted = item.IsDeleted,
        };

        await _entryRepository.AddAsync(entry);
        await _entryRepository.SaveChangesAsync();

        mappings.Add(new IdMappingDto { ClientTempId = item.ClientTempId, ServerId = entry.Id });
    }

    private static IEnumerable<T> MergeById<T>(List<T> changedSince, List<T> conflictWinners, Func<T, int> idSelector)
    {
        var byId = changedSince.ToDictionary(idSelector);
        foreach (var winner in conflictWinners)
        {
            byId.TryAdd(idSelector(winner), winner);
        }

        return byId.Values;
    }

    private static CategoryDto ToCategoryDto(Category c) => new()
    {
        Id = c.Id,
        Name = c.Name,
        Icon = c.Icon,
        Color = c.Color,
        UpdatedAt = c.UpdatedAt,
        IsDeleted = c.IsDeleted,
    };

    private static HabitDto ToHabitDto(Habito h) => new()
    {
        Id = h.Id,
        Name = h.Name,
        CategoryId = h.CategoryId,
        CategoryName = h.Category?.Name ?? string.Empty,
        CategoryIcon = h.Category?.Icon ?? string.Empty,
        CategoryColor = h.Category?.Color ?? string.Empty,
        FrequencyType = h.FrequencyType,
        IntervalDays = h.IntervalDays,
        DayOfMonth = h.DayOfMonth,
        DayOfWeek = h.DayOfWeek,
        StartDate = h.StartDate,
        UpdatedAt = h.UpdatedAt,
        IsDeleted = h.IsDeleted,
    };

    private static HabitEntryDto ToHabitEntryDto(HabitEntry e) => new()
    {
        Id = e.Id,
        HabitId = e.HabitId,
        Date = e.Date.ToString("yyyy-MM-dd"),
        Status = e.Status.ToString(),
        UpdatedAt = e.UpdatedAt,
        IsDeleted = e.IsDeleted,
    };
}
