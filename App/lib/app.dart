import 'dart:async';

import 'package:flutter/material.dart';

import 'core/app_scope.dart';
import 'core/auth/auth_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_shell.dart';

class HabitCloudApp extends StatelessWidget {
  const HabitCloudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScope(
      child: MaterialApp(
        title: 'HabitCloud',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Future<bool> _signedInFuture;

  @override
  void initState() {
    super.initState();
    _signedInFuture = _checkSignedIn();
  }

  /// Also (re)kicks off the first-login SignalR bootstrap whenever the user turns out to be
  /// signed in. That original attempt (fired right after sign-in in LoginScreen) can silently
  /// fail on a bad connection with nothing left to retry it, so every app start doubles as a
  /// retry; runInitialSyncIfNeeded() itself no-ops instantly once the bootstrap has completed.
  Future<bool> _checkSignedIn() async {
    final signedIn = await AuthService.instance.isSignedIn();
    if (signedIn && mounted) {
      unawaited(AppScope.of(context).syncService.runInitialSyncIfNeeded());
    }
    return signedIn;
  }

  void _onSignedIn() {
    setState(() {
      _signedInFuture = _checkSignedIn();
    });
  }

  void _onSignedOut() {
    setState(() {
      _signedInFuture = Future.value(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _signedInFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return snapshot.data!
            ? HomeShell(onSignedOut: _onSignedOut)
            : LoginScreen(onSignedIn: _onSignedIn);
      },
    );
  }
}
