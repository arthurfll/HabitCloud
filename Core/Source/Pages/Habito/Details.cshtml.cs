using System.Text.Json;
using Core.Source.Auth;
using Core.Source.Models.Dtos;
using Core.Source.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace Core.Source.Pages.Habito;

[Authorize]
public class DetailsModel : PageModel
{
    private static readonly JsonSerializerOptions CamelCaseJsonOptions = new(JsonSerializerDefaults.Web);

    private readonly IHabitService _habitService;

    public DetailsModel(IHabitService habitService)
    {
        _habitService = habitService;
    }

    public HabitDto Habit { get; set; } = null!;
    public int InitialYear { get; set; }
    public int InitialMonth { get; set; }
    public string InitialCalendarJson { get; set; } = "null";

    public async Task<IActionResult> OnGetAsync(int id)
    {
        var userId = User.RequireUserId();
        var result = await _habitService.GetByIdAsync(userId, id);
        if (!result.Success)
        {
            return result.Error == HabitOperationError.Forbidden ? Forbid() : NotFound();
        }

        Habit = result.Habit!;

        var today = DateTime.Now;
        InitialYear = today.Year;
        InitialMonth = today.Month;

        var (_, calendar) = await _habitService.GetCalendarAsync(userId, id, InitialYear, InitialMonth);
        InitialCalendarJson = JsonSerializer.Serialize(calendar, CamelCaseJsonOptions);

        return Page();
    }

    public async Task<IActionResult> OnGetCalendarAsync(int id, int year, int month)
    {
        var userId = User.RequireUserId();
        var (error, calendar) = await _habitService.GetCalendarAsync(userId, id, year, month);

        if (calendar is null)
        {
            var statusCode = error == HabitOperationError.Forbidden ? StatusCodes.Status403Forbidden : StatusCodes.Status404NotFound;
            return new JsonResult(new { success = false, error = error.ToString() }) { StatusCode = statusCode };
        }

        return new JsonResult(new { success = true, calendar });
    }

    public async Task<IActionResult> OnPostUpdateNameAsync(int id, string name)
    {
        var userId = User.RequireUserId();
        var result = await _habitService.UpdateNameAsync(userId, id, name);
        return ToJson(result);
    }

    public async Task<IActionResult> OnPostToggleEntryAsync(int id, string date)
    {
        var userId = User.RequireUserId();

        if (!DateOnly.TryParse(date, out var parsedDate))
        {
            return new JsonResult(new { success = false, error = "InvalidDate" }) { StatusCode = StatusCodes.Status400BadRequest };
        }

        var result = await _habitService.ToggleEntryAsync(userId, id, parsedDate);

        if (result.Success)
        {
            return new JsonResult(new { success = true, entry = result.Entry });
        }

        var statusCode = result.Error switch
        {
            HabitOperationError.NotFound => StatusCodes.Status404NotFound,
            HabitOperationError.Forbidden => StatusCodes.Status403Forbidden,
            _ => StatusCodes.Status400BadRequest,
        };

        return new JsonResult(new { success = false, error = result.Error.ToString() }) { StatusCode = statusCode };
    }

    private IActionResult ToJson(HabitResult result)
    {
        if (result.Success)
        {
            return new JsonResult(new { success = true, habit = result.Habit });
        }

        var statusCode = result.Error switch
        {
            HabitOperationError.NotFound => StatusCodes.Status404NotFound,
            HabitOperationError.Forbidden => StatusCodes.Status403Forbidden,
            _ => StatusCodes.Status400BadRequest,
        };

        return new JsonResult(new { success = false, error = result.Error.ToString() }) { StatusCode = statusCode };
    }
}
