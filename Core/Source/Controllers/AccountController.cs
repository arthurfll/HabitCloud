using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Core.Source.Auth;

namespace Core.Source.Controllers;

public class AccountController : Controller
{
    private readonly CognitoOptions _cognitoOptions;

    public AccountController(IOptions<CognitoOptions> cognitoOptions)
    {
        _cognitoOptions = cognitoOptions.Value;
    }

    public IActionResult Login(string? returnUrl = "/")
    {
        return Challenge(new AuthenticationProperties { RedirectUri = returnUrl }, OpenIdConnectDefaults.AuthenticationScheme);
    }

    public async Task<IActionResult> Logout()
    {
        await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);

        // Cognito's OIDC discovery document does not reliably advertise an end_session_endpoint,
        // so RP-initiated logout is done by hand against its Hosted UI logout endpoint instead of
        // relying on the generic OpenIdConnect handler sign-out.
        var logoutUri = Url.Action(nameof(LoggedOut), null, null, Request.Scheme);
        var cognitoLogoutUrl =
            $"https://{_cognitoOptions.Domain}/logout?client_id={Uri.EscapeDataString(_cognitoOptions.WebClientId)}&logout_uri={Uri.EscapeDataString(logoutUri!)}";

        return Redirect(cognitoLogoutUrl);
    }

    public IActionResult LoggedOut() => RedirectToAction("Index", "Home");
}
