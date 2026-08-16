using Core.Source.Models;
using Core.Source.Models.Dtos;
using Core.Source.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace Core.Source.Pages.Categoria;

[Authorize]
public class IndexModel : PageModel
{
    private readonly ICategoryService _categoryService;
    private readonly UserManager<IdentityUser> _userManager;

    public IndexModel(ICategoryService categoryService, UserManager<IdentityUser> userManager)
    {
        _categoryService = categoryService;
        _userManager = userManager;
    }

    public PagedResult<CategoryDto> Categories { get; set; } = new();

    public IReadOnlyList<string> AvailableIcons => CategoryOptions.Icons;
    public IReadOnlyList<string> AvailableColors => CategoryOptions.Colors;
    public int MaxCategories => CategoryOptions.MaxCategoriesPerUser;

    public async Task OnGetAsync(int page = 1)
    {
        var userId = _userManager.GetUserId(User)!;
        Categories = await _categoryService.GetPagedAsync(userId, page, CategoryOptions.PageSize);
    }

    public async Task<IActionResult> OnPostCreateAsync(string name, string icon, string color)
    {
        var userId = _userManager.GetUserId(User)!;
        var result = await _categoryService.CreateAsync(userId, name, icon, color);
        return ToJson(result);
    }

    public async Task<IActionResult> OnPostUpdateNameAsync(int id, string name)
    {
        var userId = _userManager.GetUserId(User)!;
        var result = await _categoryService.UpdateNameAsync(userId, id, name);
        return ToJson(result);
    }

    public async Task<IActionResult> OnPostUpdateIconAsync(int id, string icon)
    {
        var userId = _userManager.GetUserId(User)!;
        var result = await _categoryService.UpdateIconAsync(userId, id, icon);
        return ToJson(result);
    }

    public async Task<IActionResult> OnPostUpdateColorAsync(int id, string color)
    {
        var userId = _userManager.GetUserId(User)!;
        var result = await _categoryService.UpdateColorAsync(userId, id, color);
        return ToJson(result);
    }

    private IActionResult ToJson(CategoryResult result)
    {
        if (result.Success)
            return new JsonResult(new { success = true, category = result.Category });

        var statusCode = result.Error switch
        {
            CategoryOperationError.NotFound => StatusCodes.Status404NotFound,
            CategoryOperationError.Forbidden => StatusCodes.Status403Forbidden,
            _ => StatusCodes.Status400BadRequest,
        };

        return new JsonResult(new { success = false, error = result.Error.ToString() }) { StatusCode = statusCode };
    }
}
