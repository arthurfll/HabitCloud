using Core.Source.Models;
using Core.Source.Models.Dtos;
using Core.Source.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace Core.Source.Pages.Habito;

[Authorize]
public class IndexModel : PageModel
{
    private readonly IHabitService _habitService;
    private readonly ICategoryService _categoryService;
    private readonly UserManager<IdentityUser> _userManager;

    public IndexModel(IHabitService habitService, ICategoryService categoryService, UserManager<IdentityUser> userManager)
    {
        _habitService = habitService;
        _categoryService = categoryService;
        _userManager = userManager;
    }

    public List<HabitDto> Habits { get; set; } = new();
    public List<CategoryDto> Categories { get; set; } = new();
    public int MaxHabits => HabitOptions.MaxHabitsPerUser;

    public async Task OnGetAsync()
    {
        var userId = _userManager.GetUserId(User)!;
        Habits = await _habitService.GetAllAsync(userId);
        Categories = await _categoryService.GetAllAsync(userId);
    }

    public async Task<IActionResult> OnPostCreateAsync(
        string name,
        int categoryId,
        HabitFrequencyType frequencyType,
        int? intervalDays,
        int? dayOfMonth,
        DayOfWeek? dayOfWeek)
    {
        var userId = _userManager.GetUserId(User)!;
        var result = await _habitService.CreateAsync(userId, name, categoryId, frequencyType, intervalDays, dayOfMonth, dayOfWeek);
        return ToJson(result);
    }

    public async Task<IActionResult> OnPostUpdateNameAsync(int id, string name)
    {
        var userId = _userManager.GetUserId(User)!;
        var result = await _habitService.UpdateNameAsync(userId, id, name);
        return ToJson(result);
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
