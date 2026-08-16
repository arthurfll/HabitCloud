using Microsoft.AspNetCore.SignalR;

namespace Core.Source.Auth;

/// <summary>
/// SignalR's default IUserIdProvider reads ClaimTypes.NameIdentifier, which Cognito tokens don't set
/// (claims keep their original short names since MapInboundClaims is disabled). Route Clients.User(...)
/// by the "sub" claim instead, matching Category.UserId / Habito.UserId.
/// </summary>
public class CognitoUserIdProvider : IUserIdProvider
{
    public string? GetUserId(HubConnectionContext connection) => connection.User.GetUserId();
}
