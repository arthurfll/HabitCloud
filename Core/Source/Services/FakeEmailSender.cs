using Microsoft.AspNetCore.Identity.UI.Services;

namespace Core.Source.Services;

public class FakeEmailSender : IEmailSender
{
    private readonly ILogger<FakeEmailSender> _logger;

    public FakeEmailSender(ILogger<FakeEmailSender> logger)
    {
        _logger = logger;
    }

    public Task SendEmailAsync(string email, string subject, string htmlMessage)
    {
        _logger.LogInformation(
            "Fake email sender - not sending a real email.\nTo: {Email}\nSubject: {Subject}\nBody:\n{HtmlMessage}",
            email, subject, htmlMessage);

        return Task.CompletedTask;
    }
}
