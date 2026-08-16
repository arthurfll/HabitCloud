using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;

namespace Core.Source.Hubs;

[Authorize]
public class CategoryHub : Hub<ICategoryHubClient>
{
}
