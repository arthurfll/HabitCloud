using System.Diagnostics;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Core.Models;
using Core.Source.Auth;
using Core.Source.Services;

namespace Core.Controllers;

public class HomeController : Controller
{
    private readonly IHabitService _habitService;

    public HomeController(IHabitService habitService)
    {
        _habitService = habitService;
    }

    public async Task<IActionResult> Index()
    {
        if (User.Identity?.IsAuthenticated != true)
        {
            return View(new List<Core.Source.Models.Dtos.TodayHabitDto>());
        }

        var userId = User.RequireUserId();
        var habits = await _habitService.GetTodayAsync(userId);
        return View(habits);
    }

    [HttpPost]
    [Authorize]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> ToggleHabit(int id)
    {
        var userId = User.RequireUserId();
        var result = await _habitService.ToggleTodayEntryAsync(userId, id);

        if (result.Success)
        {
            return Json(new { success = true, entry = result.Entry });
        }

        var statusCode = result.Error switch
        {
            Core.Source.Models.Dtos.HabitOperationError.NotFound => StatusCodes.Status404NotFound,
            Core.Source.Models.Dtos.HabitOperationError.Forbidden => StatusCodes.Status403Forbidden,
            _ => StatusCodes.Status400BadRequest,
        };

        return StatusCode(statusCode, new { success = false, error = result.Error.ToString() });
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}
