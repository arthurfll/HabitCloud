using Core.Source.Auth;
using Core.Source.Models.Dtos;
using Core.Source.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Core.Source.Controllers.Api;

[ApiController]
[Route("api/categories")]
[Authorize(AuthenticationSchemes = "Bearer")]
public class CategoriesController : ControllerBase
{
    private readonly ICategoryService _categoryService;

    public CategoriesController(ICategoryService categoryService)
    {
        _categoryService = categoryService;
    }

    public class CreateCategoryRequest
    {
        public string Name { get; set; } = string.Empty;
        public string Icon { get; set; } = string.Empty;
        public string Color { get; set; } = string.Empty;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll() => Ok(await _categoryService.GetAllAsync(User.RequireUserId()));

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateCategoryRequest request)
    {
        var result = await _categoryService.CreateAsync(User.RequireUserId(), request.Name, request.Icon, request.Color);
        return result.Success ? Ok(result.Category) : ToErrorResult(result.Error);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] CreateCategoryRequest request)
    {
        var userId = User.RequireUserId();

        var nameResult = await _categoryService.UpdateNameAsync(userId, id, request.Name);
        if (!nameResult.Success) return ToErrorResult(nameResult.Error);

        var iconResult = await _categoryService.UpdateIconAsync(userId, id, request.Icon);
        if (!iconResult.Success) return ToErrorResult(iconResult.Error);

        var colorResult = await _categoryService.UpdateColorAsync(userId, id, request.Color);
        return colorResult.Success ? Ok(colorResult.Category) : ToErrorResult(colorResult.Error);
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var result = await _categoryService.DeleteAsync(User.RequireUserId(), id);
        return result.Success ? NoContent() : ToErrorResult(result.Error);
    }

    private IActionResult ToErrorResult(CategoryOperationError error) => error switch
    {
        CategoryOperationError.NotFound => NotFound(new { error = error.ToString() }),
        CategoryOperationError.Forbidden => Forbid(),
        _ => BadRequest(new { error = error.ToString() }),
    };
}
