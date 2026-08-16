namespace Core.Source.Auth;

public class CognitoOptions
{
    public const string SectionName = "Cognito";

    public string Region { get; set; } = string.Empty;
    public string UserPoolId { get; set; } = string.Empty;
    public string WebClientId { get; set; } = string.Empty;
    public string WebClientSecret { get; set; } = string.Empty;
    public string MobileClientId { get; set; } = string.Empty;
    public string Domain { get; set; } = string.Empty;

    public string Authority => $"https://cognito-idp.{Region}.amazonaws.com/{UserPoolId}";
}
