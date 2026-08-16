using Core.Source.Auth;
using Core.Source.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;

namespace Core.Source.Hubs;

[Authorize(AuthenticationSchemes = "Cookies,Bearer")]
public class CategoryHub : Hub<ICategoryHubClient>
{
    private readonly ICategoryService _categoryService;

    public CategoryHub(ICategoryService categoryService)
    {
        _categoryService = categoryService;
    }

    /// <summary>
    /// Called by the mobile app right after its first login (empty local database) to pull every
    /// category the user owns in one shot, in background, over the same real-time channel used for
    /// live updates.
    /// </summary>
    public async Task RequestFullSync()
    {
        var userId = Context.User!.RequireUserId();
        var categories = await _categoryService.GetAllAsync(userId);
        await Clients.Caller.FullSyncCategories(categories);
    }
}
