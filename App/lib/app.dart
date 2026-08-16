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
    _signedInFuture = AuthService.instance.isSignedIn();
  }

  void _onSignedIn() {
    setState(() {
      _signedInFuture = Future.value(true);
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
