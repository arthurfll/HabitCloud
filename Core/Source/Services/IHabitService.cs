using Core.Source.Models;
using Core.Source.Models.Dtos;

namespace Core.Source.Services;

public interface IHabitService
{
    Task<List<HabitDto>> GetAllAsync(string userId);
    Task<HabitResult> GetByIdAsync(string userId, int habitId);
    Task<HabitResult> CreateAsync(string userId, string name, int categoryId, HabitFrequencyType frequencyType, int? intervalDays, int? dayOfMonth, DayOfWeek? dayOfWeek);
    Task<HabitResult> UpdateNameAsync(string userId, int habitId, string name);
    Task<HabitResult> DeleteAsync(string userId, int habitId);
    Task<(HabitOperationError Error, HabitCalendarDto? Calendar)> GetCalendarAsync(string userId, int habitId, int year, int month);
    Task<HabitEntryResult> ToggleEntryAsync(string userId, int habitId, DateOnly date);
    Task<List<TodayHabitDto>> GetTodayAsync(string userId);
    Task<HabitEntryResult> ToggleTodayEntryAsync(string userId, int habitId);
}
