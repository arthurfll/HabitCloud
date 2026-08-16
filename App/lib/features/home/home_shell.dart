import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/auth/auth_service.dart';
import '../../core/sync/sync_service.dart';
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

class _HomeShellState extends State<HomeShell> with WidgetsBindingObserver {
  int _index = 0;
  Timer? _syncTimer;

  static const _titles = ['Hoje', 'Hábitos', 'Categorias'];
  static const _periodicSyncInterval = Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _autoSync();
    _syncTimer = Timer.periodic(_periodicSyncInterval, (_) => AppScope.of(context).syncService.requestSync());
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) AppScope.of(context).syncService.requestSync();
  }

  /// Habit entries (unlike categories/habits) never travel over the initial-login SignalR
  /// bootstrap — they only arrive via [SyncService.runBackupSync], which otherwise only fires
  /// once a day from the background job otherwise. Without this, anything marked done/not-done
  /// on the web (or another device) sits invisible in "Hoje" and the per-habit calendar until
  /// that job runs. So this kicks off the first automatic sync right after the initial bootstrap
  /// (if any) is out of the way — every local edit, app resume, and the periodic timer keep it
  /// going from there, all silently, since the user should never have to think about syncing.
  Future<void> _autoSync() async {
    final syncService = AppScope.of(context).syncService;
    if (syncService.initialSyncStatus.value == InitialSyncStatus.syncing) {
      final done = Completer<void>();
      void listener() {
        if (syncService.initialSyncStatus.value != InitialSyncStatus.syncing) {
          syncService.initialSyncStatus.removeListener(listener);
          done.complete();
        }
      }

      syncService.initialSyncStatus.addListener(listener);
      await done.future;
    }

    if (mounted) syncService.requestSync();
  }

  Future<void> _signOut() async {
    await AuthService.instance.signOut();
    widget.onSignedOut();
  }

  void _openChangePassword() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChangePasswordScreen()));
  }

  Widget _buildSyncBanner(SyncService syncService) {
    return ValueListenableBuilder<InitialSyncStatus>(
      valueListenable: syncService.initialSyncStatus,
      builder: (context, status, _) {
        switch (status) {
          case InitialSyncStatus.syncing:
            return const MaterialBanner(
              content: Text('Sincronizando seus dados...'),
              leading: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              actions: [SizedBox.shrink()],
            );
          case InitialSyncStatus.failed:
            final error = syncService.initialSyncError.value;
            return MaterialBanner(
              content: Text(
                error == null
                    ? 'Não foi possível trazer seus dados do servidor.'
                    : 'Não foi possível trazer seus dados do servidor:\n$error',
              ),
              leading: const Icon(Icons.cloud_off),
              actions: [
                TextButton(onPressed: () => syncService.runInitialSyncIfNeeded(), child: const Text('Tentar novamente')),
              ],
            );
          case InitialSyncStatus.idle:
          case InitialSyncStatus.success:
            return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final syncService = AppScope.of(context).syncService;
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          IconButton(onPressed: _openChangePassword, icon: const Icon(Icons.lock_outline), tooltip: 'Alterar senha'),
          IconButton(onPressed: _signOut, icon: const Icon(Icons.logout), tooltip: 'Sair'),
        ],
      ),
      body: Column(
        children: [
          _buildSyncBanner(syncService),
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: syncService.syncVersion,
              builder: (context, version, _) => IndexedStack(
                index: _index,
                children: [HomeScreen(key: ValueKey(version)), const HabitsScreen(), const CategoriesScreen()],
              ),
            ),
          ),
        ],
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
