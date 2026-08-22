using System.Text.Json;
using Core.Source.Auth;
using Core.Source.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace Core.Source.Pages.Stats;

[Authorize]
public class IndexModel : PageModel
{
    private static readonly JsonSerializerOptions CamelCaseJsonOptions = new(JsonSerializerDefaults.Web);

    private readonly IHabitService _habitService;

    public IndexModel(IHabitService habitService)
    {
        _habitService = habitService;
    }

    public int InitialDays { get; set; } = 30;
    public string InitialStatsJson { get; set; } = "null";

    public async Task<IActionResult> OnGetAsync()
    {
        var userId = User.RequireUserId();
        var stats = await _habitService.GetStatsAsync(userId, InitialDays);
        InitialStatsJson = JsonSerializer.Serialize(stats, CamelCaseJsonOptions);
        return Page();
    }

    public async Task<IActionResult> OnGetStatsAsync(int days)
    {
        var userId = User.RequireUserId();
        var stats = await _habitService.GetStatsAsync(userId, days);
        return new JsonResult(new { success = true, stats });
    }
}
