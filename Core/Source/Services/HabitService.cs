using Core.Source.Hubs;
using Core.Source.Models;
using Core.Source.Models.Dtos;
using Core.Source.Repositories;
using Microsoft.AspNetCore.SignalR;

namespace Core.Source.Services;

public class HabitService : IHabitService
{
    private static readonly string[] WeekdayLabels =
    {
        "Todo Domingo", "Toda Segunda-feira", "Toda Terça-feira", "Toda Quarta-feira",
        "Toda Quinta-feira", "Toda Sexta-feira", "Todo Sábado",
    };

    private readonly IHabitRepository _habitRepository;
    private readonly IHabitEntryRepository _entryRepository;
    private readonly ICategoryRepository _categoryRepository;
    private readonly IHubContext<HabitHub, IHabitHubClient> _hubContext;

    public HabitService(
        IHabitRepository habitRepository,
        IHabitEntryRepository entryRepository,
        ICategoryRepository categoryRepository,
        IHubContext<HabitHub, IHabitHubClient> hubContext)
    {
        _habitRepository = habitRepository;
        _entryRepository = entryRepository;
        _categoryRepository = categoryRepository;
        _hubContext = hubContext;
    }

    public async Task<List<HabitDto>> GetAllAsync(string userId)
    {
        var habits = await _habitRepository.GetAllByUserAsync(userId);
        return habits.Select(ToDto).ToList();
    }

    public async Task<HabitResult> GetByIdAsync(string userId, int habitId)
    {
        var habit = await _habitRepository.GetByIdAsync(habitId);
        var ownershipError = ValidateOwnership(habit, userId);
        if (ownershipError is not null)
        {
            return HabitResult.Fail(ownershipError.Value);
        }

        return HabitResult.Ok(ToDto(habit!));
    }

    public async Task<HabitResult> CreateAsync(
        string userId,
        string name,
        int categoryId,
        HabitFrequencyType frequencyType,
        int? intervalDays,
        int? dayOfMonth,
        DayOfWeek? dayOfWeek)
    {
        name = name?.Trim() ?? string.Empty;
        if (string.IsNullOrWhiteSpace(name) || name.Length > 50)
        {
            return HabitResult.Fail(HabitOperationError.InvalidName);
        }

        var category = await _categoryRepository.GetByIdAsync(categoryId);
        if (category is null || category.IsDeleted || !string.Equals(category.UserId, userId, StringComparison.Ordinal))
        {
            return HabitResult.Fail(HabitOperationError.InvalidCategory);
        }

        var frequencyError = ValidateFrequency(frequencyType, intervalDays, dayOfMonth, dayOfWeek);
        if (frequencyError is not null)
        {
            return HabitResult.Fail(frequencyError.Value);
        }

        var currentCount = await _habitRepository.CountByUserAsync(userId);
        if (currentCount >= HabitOptions.MaxHabitsPerUser)
        {
            return HabitResult.Fail(HabitOperationError.LimitReached);
        }

        var now = DateTime.UtcNow;
        var habit = new Habito
        {
            Name = name,
            UserId = userId,
            CategoryId = categoryId,
            FrequencyType = frequencyType,
            IntervalDays = frequencyType == HabitFrequencyType.EveryNDays ? intervalDays : null,
            DayOfMonth = frequencyType == HabitFrequencyType.DayOfMonth ? dayOfMonth : null,
            DayOfWeek = frequencyType == HabitFrequencyType.DayOfWeek ? dayOfWeek : null,
            StartDate = DateOnly.FromDateTime(DateTime.Now),
            CreatedAt = now,
            UpdatedAt = now,
        };

        await _habitRepository.AddAsync(habit);
        await _habitRepository.SaveChangesAsync();

        habit.Category = category;
        var dto = ToDto(habit);
        await _hubContext.Clients.User(userId).HabitCreated(dto);

        return HabitResult.Ok(dto);
    }

    public async Task<HabitResult> UpdateNameAsync(string userId, int habitId, string name)
    {
        name = name?.Trim() ?? string.Empty;
        if (string.IsNullOrWhiteSpace(name) || name.Length > 50)
        {
            return HabitResult.Fail(HabitOperationError.InvalidName);
        }

        var habit = await _habitRepository.GetByIdAsync(habitId);
        var ownershipError = ValidateOwnership(habit, userId);
        if (ownershipError is not null)
        {
            return HabitResult.Fail(ownershipError.Value);
        }

        habit!.Name = name;
        habit.UpdatedAt = DateTime.UtcNow;
        _habitRepository.Update(habit);
        await _habitRepository.SaveChangesAsync();

        var dto = ToDto(habit);
        await _hubContext.Clients.User(userId).HabitUpdated(dto);

        return HabitResult.Ok(dto);
    }

    public async Task<HabitResult> DeleteAsync(string userId, int habitId)
    {
        var habit = await _habitRepository.GetByIdAsync(habitId);
        var ownershipError = ValidateOwnership(habit, userId);
        if (ownershipError is not null)
        {
            return HabitResult.Fail(ownershipError.Value);
        }

        habit!.IsDeleted = true;
        habit.UpdatedAt = DateTime.UtcNow;
        _habitRepository.Update(habit);
        await _habitRepository.SaveChangesAsync();

        var dto = ToDto(habit);
        await _hubContext.Clients.User(userId).HabitDeleted(dto);

        return HabitResult.Ok(dto);
    }

    public async Task<(HabitOperationError Error, HabitCalendarDto? Calendar)> GetCalendarAsync(string userId, int habitId, int year, int month)
    {
        var habit = await _habitRepository.GetByIdAsync(habitId);
        var ownershipError = ValidateOwnership(habit, userId);
        if (ownershipError is not null)
        {
            return (ownershipError.Value, null);
        }

        var daysInMonth = DateTime.DaysInMonth(year, month);
        var start = new DateOnly(year, month, 1);
        var end = new DateOnly(year, month, daysInMonth);

        var entries = await _entryRepository.GetRangeAsync(habitId, start, end);
        var entriesByDate = entries.ToDictionary(e => e.Date, e => e.Status);

        var days = new List<HabitCalendarDayDto>(daysInMonth);
        for (var day = 1; day <= daysInMonth; day++)
        {
            var date = new DateOnly(year, month, day);
            days.Add(new HabitCalendarDayDto
            {
                HabitId = habitId,
                Date = date.ToString("yyyy-MM-dd"),
                Due = HabitScheduleCalculator.IsDue(habit!, date),
                Status = entriesByDate.TryGetValue(date, out var status) ? status.ToString() : "None",
            });
        }

        return (HabitOperationError.None, new HabitCalendarDto { HabitId = habitId, Year = year, Month = month, Days = days });
    }

    public async Task<HabitEntryResult> ToggleEntryAsync(string userId, int habitId, DateOnly date)
    {
        var habit = await _habitRepository.GetByIdAsync(habitId);
        var ownershipError = ValidateOwnership(habit, userId);
        if (ownershipError is not null)
        {
            return HabitEntryResult.Fail(ownershipError.Value);
        }

        if (!HabitScheduleCalculator.IsDue(habit!, date))
        {
            return HabitEntryResult.Fail(HabitOperationError.NotDue);
        }

        var entry = await _entryRepository.GetAsync(habitId, date);
        var now = DateTime.UtcNow;
        string newStatus;

        if (entry is null || entry.IsDeleted)
        {
            // A previously toggled-off entry is soft-deleted (tombstoned) for sync purposes, not
            // removed, so the unique (HabitId, Date) index requires reviving that same row instead
            // of inserting a fresh one.
            if (entry is null)
            {
                entry = new HabitEntry { HabitId = habitId, Date = date, Status = HabitEntryStatus.Done, CreatedAt = now, UpdatedAt = now };
                await _entryRepository.AddAsync(entry);
            }
            else
            {
                entry.Status = HabitEntryStatus.Done;
                entry.IsDeleted = false;
                entry.UpdatedAt = now;
                _entryRepository.Update(entry);
            }

            newStatus = HabitEntryStatus.Done.ToString();
        }
        else if (entry.Status == HabitEntryStatus.Done)
        {
            entry.Status = HabitEntryStatus.NotDone;
            entry.UpdatedAt = now;
            _entryRepository.Update(entry);
            newStatus = HabitEntryStatus.NotDone.ToString();
        }
        else
        {
            entry.IsDeleted = true;
            entry.UpdatedAt = now;
            _entryRepository.Update(entry);
            newStatus = "None";
        }

        await _entryRepository.SaveChangesAsync();

        var dayDto = new HabitCalendarDayDto
        {
            HabitId = habitId,
            Date = date.ToString("yyyy-MM-dd"),
            Due = true,
            Status = newStatus,
        };

        await _hubContext.Clients.User(userId).HabitEntryUpdated(dayDto);

        return HabitEntryResult.Ok(dayDto);
    }

    public async Task<List<TodayHabitDto>> GetTodayAsync(string userId)
    {
        var today = DateOnly.FromDateTime(DateTime.Now);
        var habits = await _habitRepository.GetAllByUserAsync(userId);
        var dueToday = habits.Where(h => HabitScheduleCalculator.IsDue(h, today)).ToList();

        if (dueToday.Count == 0)
        {
            return new List<TodayHabitDto>();
        }

        var habitIds = dueToday.Select(h => h.Id).ToList();
        var entries = await _entryRepository.GetForHabitsOnDateAsync(habitIds, today);
        var statusByHabitId = entries.ToDictionary(e => e.HabitId, e => e.Status);

        return dueToday.Select(h => new TodayHabitDto
        {
            Id = h.Id,
            Name = h.Name,
            CategoryIcon = h.Category!.Icon,
            CategoryColor = h.Category.Color,
            Status = statusByHabitId.TryGetValue(h.Id, out var status) ? status.ToString() : "None",
        }).ToList();
    }

    public Task<HabitEntryResult> ToggleTodayEntryAsync(string userId, int habitId) =>
        ToggleEntryAsync(userId, habitId, DateOnly.FromDateTime(DateTime.Now));

    private static HabitOperationError? ValidateOwnership(Habito? habit, string userId)
    {
        if (habit is null || habit.IsDeleted)
        {
            return HabitOperationError.NotFound;
        }

        if (!string.Equals(habit.UserId, userId, StringComparison.Ordinal))
        {
            return HabitOperationError.Forbidden;
        }

        return null;
    }

    public static HabitOperationError? ValidateFrequency(HabitFrequencyType type, int? intervalDays, int? dayOfMonth, DayOfWeek? dayOfWeek)
    {
        switch (type)
        {
            case HabitFrequencyType.EveryNDays:
                if (intervalDays is null || intervalDays < HabitOptions.MinIntervalDays || intervalDays > HabitOptions.MaxIntervalDays)
                {
                    return HabitOperationError.InvalidFrequency;
                }
                break;
            case HabitFrequencyType.DayOfMonth:
                if (dayOfMonth is null || dayOfMonth < HabitOptions.MinDayOfMonth || dayOfMonth > HabitOptions.MaxDayOfMonth)
                {
                    return HabitOperationError.InvalidFrequency;
                }
                break;
            case HabitFrequencyType.DayOfWeek:
                if (dayOfWeek is null)
                {
                    return HabitOperationError.InvalidFrequency;
                }
                break;
            default:
                return HabitOperationError.InvalidFrequency;
        }

        return null;
    }

    private static string BuildFrequencyLabel(Habito habit) => habit.FrequencyType switch
    {
        HabitFrequencyType.EveryNDays => (habit.IntervalDays ?? 0) <= 0
            ? "Todo dia"
            : $"A cada {habit.IntervalDays} dias",
        HabitFrequencyType.DayOfMonth => $"Todo dia {habit.DayOfMonth} do mês",
        HabitFrequencyType.DayOfWeek => WeekdayLabels[(int)(habit.DayOfWeek ?? System.DayOfWeek.Sunday)],
        _ => string.Empty,
    };

    private static HabitDto ToDto(Habito habit) => new()
    {
        Id = habit.Id,
        Name = habit.Name,
        CategoryId = habit.CategoryId,
        CategoryName = habit.Category?.Name ?? string.Empty,
        CategoryIcon = habit.Category?.Icon ?? string.Empty,
        CategoryColor = habit.Category?.Color ?? string.Empty,
        FrequencyType = habit.FrequencyType,
        IntervalDays = habit.IntervalDays,
        DayOfMonth = habit.DayOfMonth,
        DayOfWeek = habit.DayOfWeek,
        StartDate = habit.StartDate,
        FrequencyLabel = BuildFrequencyLabel(habit),
        UpdatedAt = habit.UpdatedAt,
        IsDeleted = habit.IsDeleted,
    };
}
