/// Cognito / API configuration. The User Pool id and region are already the real values from the
/// HabitCloud User Pool; MobileClientId/Domain are placeholders until the corresponding App Client
/// is created (or its id is provided) in the AWS console. None of these are secrets — a public
/// Cognito App Client id is meant to ship inside the app binary, unlike the web app client's secret,
/// which stays server-side in Core's appsettings.json only.
class Env {
  Env._();

  static const awsRegion = 'us-east-2';
  static const cognitoUserPoolId = 'us-east-2_nOT6osznS';
  static const cognitoMobileClientId = '3a9o589v2st242a0gbtvd8h57j';

  /// Cognito Hosted UI domain, e.g. "habitcloud.auth.us-east-2.amazoncognito.com".
  static const cognitoDomain = 'us-east-2not6oszns.auth.us-east-2.amazoncognito.com';

  /// Base URL of the Core API. Defaults to the public production deployment; override with
  /// --dart-define=API_BASE_URL=http://10.0.2.2:8080 to hit a Core instance running locally
  /// via the Android emulator's loopback alias to the host machine instead.
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://www.habitcloud.arthurfll.net',
  );

  static String get categoryHubUrl => '$apiBaseUrl/hubs/category';
  static String get habitHubUrl => '$apiBaseUrl/hubs/habit';
}
