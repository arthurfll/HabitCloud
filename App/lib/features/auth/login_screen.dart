import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/auth/auth_service.dart';
import '../../core/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onSignedIn;

  const LoginScreen({super.key, required this.onSignedIn});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum _Mode { signIn, signUp, confirmSignUp }

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();

  _Mode _mode = _Mode.signIn;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      switch (_mode) {
        case _Mode.signIn:
          await AuthService.instance.signIn(email: _emailController.text.trim(), password: _passwordController.text);
          await _completeSignIn();
        case _Mode.signUp:
          await AuthService.instance.signUp(email: _emailController.text.trim(), password: _passwordController.text);
          setState(() => _mode = _Mode.confirmSignUp);
        case _Mode.confirmSignUp:
          await AuthService.instance.confirmSignUp(email: _emailController.text.trim(), code: _codeController.text.trim());
          await AuthService.instance.signIn(email: _emailController.text.trim(), password: _passwordController.text);
          await _completeSignIn();
      }
    } on AmplifyException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _completeSignIn() async {
    if (!mounted) return;
    // Kicks off the first-login background pull (SignalR RequestFullSync) without blocking the UI.
    unawaited(AppScope.of(context).syncService.runInitialSyncIfNeeded());
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
                            if (_mode != _Mode.confirmSignUp) ...[
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(labelText: 'E-mail'),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(labelText: 'Senha'),
                              ),
                            ] else ...[
                              Text('Digite o código enviado para ${_emailController.text}'),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _codeController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: 'Código de confirmação'),
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
                                      }),
                              ),
                            ),
                            if (_mode == _Mode.signIn)
                              TextButton(
                                onPressed: _loading ? null : () => setState(() => _mode = _Mode.signUp),
                                child: const Text('Não tem conta? Criar conta'),
                              )
                            else if (_mode == _Mode.signUp)
                              TextButton(
                                onPressed: _loading ? null : () => setState(() => _mode = _Mode.signIn),
                                child: const Text('Já tem conta? Entrar'),
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
