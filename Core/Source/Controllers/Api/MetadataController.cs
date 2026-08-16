using Core.Source.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Core.Source.Controllers.Api;

[ApiController]
[Route("api/metadata")]
[Authorize(AuthenticationSchemes = "Bearer")]
public class MetadataController : ControllerBase
{
    [HttpGet("category-options")]
    public IActionResult GetCategoryOptions() => Ok(new
    {
        icons = CategoryOptions.Icons,
        colors = CategoryOptions.Colors,
        maxCategoriesPerUser = CategoryOptions.MaxCategoriesPerUser,
        maxHabitsPerUser = HabitOptions.MaxHabitsPerUser,
    });
}
