using System.Security.Claims;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Core.Source.Auth;
using Core.Source.Data;
using Core.Source.Hubs;
using Core.Source.Repositories;
using Core.Source.Services;

var builder = WebApplication.CreateBuilder(args);
var connectionString = builder.Configuration.GetConnectionString("AppDbContextConnection") ?? throw new InvalidOperationException("Connection string 'AppDbContextConnection' not found.");

builder.Services.AddDbContext<AppDbContext>(options => options.UseNpgsql(connectionString));

var cognitoOptions = builder.Configuration.GetSection(CognitoOptions.SectionName).Get<CognitoOptions>()
    ?? throw new InvalidOperationException($"Configuration section '{CognitoOptions.SectionName}' not found.");
builder.Services.Configure<CognitoOptions>(builder.Configuration.GetSection(CognitoOptions.SectionName));

builder.Services.AddScoped<ICategoryRepository, CategoryRepository>();
builder.Services.AddScoped<ICategoryService, CategoryService>();
builder.Services.AddScoped<IHabitRepository, HabitRepository>();
builder.Services.AddScoped<IHabitEntryRepository, HabitEntryRepository>();
builder.Services.AddScoped<IHabitService, HabitService>();
builder.Services.AddScoped<ISyncService, SyncService>();
builder.Services.AddSignalR();
builder.Services.AddSingleton<IUserIdProvider, CognitoUserIdProvider>();

builder.Services
    .AddAuthentication(options =>
    {
        options.DefaultScheme = CookieAuthenticationDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = OpenIdConnectDefaults.AuthenticationScheme;
        options.DefaultSignOutScheme = OpenIdConnectDefaults.AuthenticationScheme;
    })
    .AddCookie()
    .AddOpenIdConnect(options =>
    {
        options.Authority = cognitoOptions.Authority;
        options.ClientId = cognitoOptions.WebClientId;
        options.ClientSecret = cognitoOptions.WebClientSecret;
        options.ResponseType = "code";
        options.SaveTokens = true;
        options.MapInboundClaims = false;
        options.Scope.Clear();
        options.Scope.Add("openid");
        options.Scope.Add("email");
        options.Scope.Add("profile");
        options.TokenValidationParameters.NameClaimType = "email";
    })
    .AddJwtBearer("Bearer", options =>
    {
        options.Authority = cognitoOptions.Authority;
        options.MapInboundClaims = false;
        // Cognito access tokens carry "client_id" (no "aud"); id tokens carry "aud" instead.
        // Built-in audience validation only understands "aud", so it is disabled and replaced
        // with a check that accepts either shape as long as it names our mobile app client.
        options.TokenValidationParameters.ValidateAudience = false;
        options.Events = new JwtBearerEvents
        {
            OnTokenValidated = context =>
            {
                var clientId = context.Principal?.FindFirst("client_id")?.Value
                    ?? context.Principal?.FindFirst("aud")?.Value;

                if (!string.Equals(clientId, cognitoOptions.MobileClientId, StringComparison.Ordinal))
                {
                    context.Fail("Token was not issued for the HabitCloud mobile app client.");
                }

                return Task.CompletedTask;
            },
            OnMessageReceived = context =>
            {
                var accessToken = context.Request.Query["access_token"];
                if (!string.IsNullOrEmpty(accessToken) && context.HttpContext.Request.Path.StartsWithSegments("/hubs"))
                {
                    context.Token = accessToken;
                }

                return Task.CompletedTask;
            },
        };
    });

builder.Services.AddAuthorization();

builder.Services.AddAntiforgery(options => options.HeaderName = "X-CSRF-TOKEN");

// Add services to the container.
builder.Services.AddControllersWithViews();
builder.Services.AddRazorPages(options =>
{
    options.RootDirectory = "/Source/Pages";
});

var app = builder.Build();

// The container only listens on plain HTTP (Core/Dockerfile: ASPNETCORE_URLS=http://+:7010) — TLS is
// terminated by Azure Container Apps' ingress in front of it. Without this, the app sees every request
// as HTTP, so the OIDC handler builds an http:// redirect_uri for the Cognito callback; the platform's
// own http->https redirect then strips the query string (state/code) before it reaches /signin-oidc.
var forwardedHeadersOptions = new ForwardedHeadersOptions
{
    ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto,
};
// Azure Container Apps' ingress isn't loopback, so the default KnownIPNetworks/KnownProxies
// restriction (loopback only) would silently ignore its forwarded headers unless cleared.
forwardedHeadersOptions.KnownIPNetworks.Clear();
forwardedHeadersOptions.KnownProxies.Clear();
app.UseForwardedHeaders(forwardedHeadersOptions);

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.MapStaticAssets();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}")
    .WithStaticAssets();

app.MapRazorPages()
    .WithStaticAssets();

app.MapHub<CategoryHub>("/hubs/category");
app.MapHub<HabitHub>("/hubs/habit");

app.Run();
