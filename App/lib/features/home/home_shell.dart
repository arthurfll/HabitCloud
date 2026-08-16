import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../auth/change_password_screen.dart';
import '../categories/categories_screen.dart';
import '../habits/habits_screen.dart';
import 'home_screen.dart';

class HomeShell extends StatefulWidget {
  final VoidCallback onSignedOut;

  const HomeShell({super.key, required this.onSignedOut});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _titles = ['Hoje', 'Hábitos', 'Categorias'];

  Future<void> _signOut() async {
    await AuthService.instance.signOut();
    widget.onSignedOut();
  }

  void _openChangePassword() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChangePasswordScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          IconButton(onPressed: _openChangePassword, icon: const Icon(Icons.lock_outline), tooltip: 'Alterar senha'),
          IconButton(onPressed: _signOut, icon: const Icon(Icons.logout), tooltip: 'Sair'),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: const [HomeScreen(), HabitsScreen(), CategoriesScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today_outlined), selectedIcon: Icon(Icons.today), label: 'Hoje'),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Hábitos',
          ),
          NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view), label: 'Categorias'),
        ],
      ),
    );
  }
}
