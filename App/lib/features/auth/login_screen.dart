import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onSignedIn;

  const LoginScreen({super.key, required this.onSignedIn});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum _Mode { signIn, signUp, confirmSignUp, forgotPassword, confirmForgotPassword }

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();

  _Mode _mode = _Mode.signIn;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final email = _emailController.text.trim();

    try {
      switch (_mode) {
        case _Mode.signIn:
          await AuthService.instance.signIn(email: email, password: _passwordController.text);
          await _completeSignIn();
        case _Mode.signUp:
          await AuthService.instance.signUp(email: email, password: _passwordController.text);
          setState(() => _mode = _Mode.confirmSignUp);
        case _Mode.confirmSignUp:
          await AuthService.instance.confirmSignUp(email: email, code: _codeController.text.trim());
          await AuthService.instance.signIn(email: email, password: _passwordController.text);
          await _completeSignIn();
        case _Mode.forgotPassword:
          await AuthService.instance.resetPassword(email: email);
          setState(() => _mode = _Mode.confirmForgotPassword);
        case _Mode.confirmForgotPassword:
          await AuthService.instance.confirmResetPassword(
            email: email,
            newPassword: _newPasswordController.text,
            code: _codeController.text.trim(),
          );
          await AuthService.instance.signIn(email: email, password: _newPasswordController.text);
          await _completeSignIn();
      }
    } on UserNotConfirmedException {
      // The account exists but was never confirmed (e.g. an abandoned sign-up). Resend the code
      // instead of letting the user fall back to creating a brand new, duplicate account.
      try {
        await AuthService.instance.resendSignUpCode(email: email);
        setState(() {
          _mode = _Mode.confirmSignUp;
          _error = 'Essa conta ainda não foi confirmada. Enviamos um novo código para o seu e-mail.';
        });
      } on AmplifyException catch (e) {
        setState(() => _error = e.message);
      }
    } on UserNotFoundException {
      setState(() => _error = 'Não encontramos uma conta com esse e-mail.');
    } on NotAuthorizedServiceException {
      setState(() => _error = _mode == _Mode.signIn ? 'E-mail ou senha incorretos.' : 'Não foi possível concluir. Verifique os dados e tente novamente.');
    } on UsernameExistsException {
      setState(() => _error = 'Já existe uma conta com esse e-mail. Tente entrar ou toque em "Esqueci minha senha".');
    } on CodeMismatchException {
      setState(() => _error = 'Código inválido. Confira e tente novamente.');
    } on ExpiredCodeException {
      setState(() => _error = 'Esse código expirou. Solicite um novo.');
    } on AmplifyException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _completeSignIn() async {
    if (!mounted) return;
    // AuthGate kicks off the first-login background pull (SignalR RequestFullSync) as soon as it
    // sees the signed-in state; it also retries this on every later app start in case this attempt
    // doesn't finish before the app is backgrounded or killed.
    widget.onSignedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud, color: Colors.white, size: 72),
                    const SizedBox(height: 12),
                    const Text(
                      'HabitCloud',
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_mode == _Mode.signIn || _mode == _Mode.signUp || _mode == _Mode.forgotPassword) ...[
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(labelText: 'E-mail'),
                              ),
                              if (_mode != _Mode.forgotPassword) ...[
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(labelText: 'Senha'),
                                ),
                              ],
                            ] else if (_mode == _Mode.confirmSignUp) ...[
                              Text('Digite o código enviado para ${_emailController.text}'),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _codeController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: 'Código de confirmação'),
                              ),
                            ] else ...[
                              Text('Digite o código enviado para ${_emailController.text} e a nova senha'),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _codeController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: 'Código de confirmação'),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _newPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(labelText: 'Nova senha'),
                              ),
                            ],
                            if (_error != null) ...[
                              const SizedBox(height: 12),
                              Text(_error!, style: const TextStyle(color: Colors.red)),
                            ],
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _loading ? null : _submit,
                                child: _loading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : Text(switch (_mode) {
                                        _Mode.signIn => 'Entrar',
                                        _Mode.signUp => 'Criar conta',
                                        _Mode.confirmSignUp => 'Confirmar',
                                        _Mode.forgotPassword => 'Enviar código',
                                        _Mode.confirmForgotPassword => 'Redefinir senha',
                                      }),
                              ),
                            ),
                            if (_mode == _Mode.signIn) ...[
                              TextButton(
                                onPressed: _loading ? null : () => setState(() => _mode = _Mode.signUp),
                                child: const Text('Não tem conta? Criar conta'),
                              ),
                              TextButton(
                                onPressed: _loading
                                    ? null
                                    : () => setState(() {
                                        _mode = _Mode.forgotPassword;
                                        _error = null;
                                      }),
                                child: const Text('Esqueceu a senha?'),
                              ),
                            ] else if (_mode == _Mode.signUp)
                              TextButton(
                                onPressed: _loading ? null : () => setState(() => _mode = _Mode.signIn),
                                child: const Text('Já tem conta? Entrar'),
                              )
                            else if (_mode == _Mode.forgotPassword)
                              TextButton(
                                onPressed: _loading
                                    ? null
                                    : () => setState(() {
                                        _mode = _Mode.signIn;
                                        _error = null;
                                      }),
                                child: const Text('Voltar para login'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
