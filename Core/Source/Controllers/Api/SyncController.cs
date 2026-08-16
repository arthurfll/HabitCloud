using Core.Source.Auth;
using Core.Source.Models.Dtos.Sync;
using Core.Source.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Core.Source.Controllers.Api;

[ApiController]
[Route("api/sync")]
[Authorize(AuthenticationSchemes = "Bearer")]
public class SyncController : ControllerBase
{
    private readonly ISyncService _syncService;

    public SyncController(ISyncService syncService)
    {
        _syncService = syncService;
    }

    /// <summary>
    /// Used by the mobile app's ~2am background backup job: uploads whatever changed locally since
    /// the last sync and receives back everything the server considers newer (its own accepted
    /// changes, anything changed on the web, and the server's copy of any record that won a
    /// last-write-wins conflict against the client's version).
    /// </summary>
    [HttpPost]
    public async Task<IActionResult> Sync([FromBody] SyncRequestDto request) =>
        Ok(await _syncService.SyncAsync(User.RequireUserId(), request));
}
