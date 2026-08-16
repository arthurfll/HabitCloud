using Core.Source.Models.Dtos.Sync;

namespace Core.Source.Services;

public interface ISyncService
{
    Task<SyncResponseDto> SyncAsync(string userId, SyncRequestDto request);
}
