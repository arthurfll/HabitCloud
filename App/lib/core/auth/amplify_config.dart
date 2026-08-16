import '../config/env.dart';

/// Hand-authored Amplify CLI-style config for a Cognito User Pool-only setup (no Identity Pool —
/// the app never calls AWS services directly, only Core's API/hub with the pool's JWTs), built
/// from [Env] so there is a single place to update once the real mobile App Client id is known.
String buildAmplifyConfig() => '''
{
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "UserAgent": "aws-amplify-cli/0.1.0",
        "Version": "0.1.0",
        "IdentityManager": { "Default": {} },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "${Env.cognitoUserPoolId}",
            "AppClientId": "${Env.cognitoMobileClientId}",
            "Region": "${Env.awsRegion}"
          }
        },
        "Auth": {
          "Default": {
            "authenticationFlowType": "USER_SRP_AUTH"
          }
        }
      }
    }
  }
}
''';
