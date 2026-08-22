using Core.Source.Auth;
using Core.Source.Models;
using Core.Source.Models.Dtos;
using Core.Source.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Core.Source.Controllers.Api;

[ApiController]
[Route("api/habits")]
[Authorize(AuthenticationSchemes = "Bearer")]
public class HabitsController : ControllerBase
{
    private readonly IHabitService _habitService;

    public HabitsController(IHabitService habitService)
    {
        _habitService = habitService;
    }

    public class CreateHabitRequest
    {
        public string Name { get; set; } = string.Empty;
        public int CategoryId { get; set; }
        public HabitFrequencyType FrequencyType { get; set; }
        public int? IntervalDays { get; set; }
        public int? DayOfMonth { get; set; }
        public DayOfWeek? DayOfWeek { get; set; }
    }

    [HttpGet]
    public async Task<IActionResult> GetAll() => Ok(await _habitService.GetAllAsync(User.RequireUserId()));

    [HttpGet("today")]
    public async Task<IActionResult> GetToday() => Ok(await _habitService.GetTodayAsync(User.RequireUserId()));

    [HttpGet("stats")]
    public async Task<IActionResult> GetStats([FromQuery] int days = 30) =>
        Ok(await _habitService.GetStatsAsync(User.RequireUserId(), days));

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var result = await _habitService.GetByIdAsync(User.RequireUserId(), id);
        return result.Success ? Ok(result.Habit) : ToErrorResult(result.Error);
    }

    [HttpGet("{id:int}/calendar")]
    public async Task<IActionResult> GetCalendar(int id, [FromQuery] int year, [FromQuery] int month)
    {
        var (error, calendar) = await _habitService.GetCalendarAsync(User.RequireUserId(), id, year, month);
        return calendar is not null ? Ok(calendar) : ToErrorResult(error);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateHabitRequest request)
    {
        var result = await _habitService.CreateAsync(
            User.RequireUserId(), request.Name, request.CategoryId, request.FrequencyType,
            request.IntervalDays, request.DayOfMonth, request.DayOfWeek);
        return result.Success ? Ok(result.Habit) : ToErrorResult(result.Error);
    }

    [HttpPut("{id:int}/name")]
    public async Task<IActionResult> UpdateName(int id, [FromBody] string name)
    {
        var result = await _habitService.UpdateNameAsync(User.RequireUserId(), id, name);
        return result.Success ? Ok(result.Habit) : ToErrorResult(result.Error);
    }

    [HttpPost("{id:int}/toggle")]
    public async Task<IActionResult> ToggleEntry(int id, [FromQuery] string? date)
    {
        var userId = User.RequireUserId();
        var result = date is not null && DateOnly.TryParse(date, out var parsedDate)
            ? await _habitService.ToggleEntryAsync(userId, id, parsedDate)
            : await _habitService.ToggleTodayEntryAsync(userId, id);

        return result.Success ? Ok(result.Entry) : ToErrorResult(result.Error);
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var result = await _habitService.DeleteAsync(User.RequireUserId(), id);
        return result.Success ? NoContent() : ToErrorResult(result.Error);
    }

    private IActionResult ToErrorResult(HabitOperationError error) => error switch
    {
        HabitOperationError.NotFound => NotFound(new { error = error.ToString() }),
        HabitOperationError.Forbidden => Forbid(),
        _ => BadRequest(new { error = error.ToString() }),
    };
}
