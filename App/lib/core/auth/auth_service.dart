import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'amplify_config.dart';

/// Thin wrapper around Amplify Auth. Amplify persists Cognito tokens in secure storage
/// (EncryptedSharedPreferences-backed on Android) and refreshes them automatically using the
/// refresh token, so a signed-in session survives app/device restarts and is only cleared by an
/// explicit sign-out or the app being uninstalled — as long as the Cognito App Client's refresh
/// token validity is configured to its maximum in the User Pool (see App/COGNITO_SETUP.md).
class AuthService {
  static final AuthService instance = AuthService._();
  AuthService._();

  bool _configured = false;

  Future<void> configure() async {
    if (_configured) return;
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(buildAmplifyConfig());
    } on AmplifyAlreadyConfiguredException {
      // Hot restart during development re-runs main() without resetting the Amplify singleton.
    }
    _configured = true;
  }

  Future<bool> isSignedIn() async {
    final session = await Amplify.Auth.fetchAuthSession();
    return session.isSignedIn;
  }

  /// The Cognito "sub" — the stable user id shared with Core (Category.UserId / Habito.UserId).
  Future<String?> currentUserId() async {
    if (!await isSignedIn()) return null;
    final user = await Amplify.Auth.getCurrentUser();
    return user.userId;
  }

  Future<String?> currentAccessToken() async {
    final session = await Amplify.Auth.fetchAuthSession();
    if (session is! CognitoAuthSession) return null;
    return session.userPoolTokensResult.valueOrNull?.accessToken.raw;
  }

  Future<SignInResult> signIn({required String email, required String password}) {
    return Amplify.Auth.signIn(username: email, password: password);
  }

  Future<SignUpResult> signUp({required String email, required String password}) {
    return Amplify.Auth.signUp(
      username: email,
      password: password,
      options: SignUpOptions(userAttributes: {AuthUserAttributeKey.email: email}),
    );
  }

  Future<SignUpResult> confirmSignUp({required String email, required String code}) {
    return Amplify.Auth.confirmSignUp(username: email, confirmationCode: code);
  }

  Future<ResendSignUpCodeResult> resendSignUpCode({required String email}) {
    return Amplify.Auth.resendSignUpCode(username: email);
  }

  Future<ResetPasswordResult> resetPassword({required String email}) {
    return Amplify.Auth.resetPassword(username: email);
  }

  Future<void> confirmResetPassword({
    required String email,
    required String newPassword,
    required String code,
  }) {
    return Amplify.Auth.confirmResetPassword(username: email, newPassword: newPassword, confirmationCode: code);
  }

  Future<void> updatePassword({required String oldPassword, required String newPassword}) {
    return Amplify.Auth.updatePassword(oldPassword: oldPassword, newPassword: newPassword);
  }

  Future<void> signOut() => Amplify.Auth.signOut();
}
