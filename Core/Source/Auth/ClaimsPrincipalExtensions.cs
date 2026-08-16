using System.Security.Claims;

namespace Core.Source.Auth;

public static class ClaimsPrincipalExtensions
{
    /// <summary>
    /// Cognito's "sub" claim is the stable user id used everywhere in the app (Category.UserId,
    /// Habito.UserId, SignalR user identifier). Both the web cookie session (from the OIDC id_token)
    /// and the mobile bearer token (from the Cognito access/id token) carry this claim under its
    /// original short name because MapInboundClaims is disabled for both auth schemes.
    /// </summary>
    public static string? GetUserId(this ClaimsPrincipal user) => user.FindFirst("sub")?.Value;

    public static string RequireUserId(this ClaimsPrincipal user) =>
        user.GetUserId() ?? throw new InvalidOperationException("Authenticated principal has no 'sub' claim.");

    public static string? GetEmail(this ClaimsPrincipal user) => user.FindFirst("email")?.Value;
}
