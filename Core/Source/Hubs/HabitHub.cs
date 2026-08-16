using Core.Source.Auth;
using Core.Source.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;

namespace Core.Source.Hubs;

[Authorize(AuthenticationSchemes = "Cookies,Bearer")]
public class HabitHub : Hub<IHabitHubClient>
{
    private readonly IHabitService _habitService;

    public HabitHub(IHabitService habitService)
    {
        _habitService = habitService;
    }

    /// <summary>
    /// Called by the mobile app right after its first login (empty local database) to pull every
    /// habit the user owns in one shot, in background, over the same real-time channel used for
    /// live updates.
    /// </summary>
    public async Task RequestFullSync()
    {
        var userId = Context.User!.RequireUserId();
        var habits = await _habitService.GetAllAsync(userId);
        await Clients.Caller.FullSyncHabits(habits);
    }
}
