import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/db/habit_repository.dart';
import '../../core/icons/bootstrap_icon_map.dart';
import '../../core/models/habit_entry_model.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/color_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _TodayItem {
  final HabitWithCategory habit;
  final String status;

  _TodayItem(this.habit, this.status);
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<_TodayItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<_TodayItem>> _load() async {
    final repo = AppScope.of(context).habitRepository;
    final due = await repo.getDueToday();
    final today = DateTime.now();
    final items = <_TodayItem>[];
    for (final h in due) {
      final entry = await repo.getEntry(h.habit.id, today);
      items.add(_TodayItem(h, entry?.status ?? HabitEntryStatus.none));
    }
    return items;
  }

  Future<void> _toggle(_TodayItem item) async {
    await AppScope.of(context).habitRepository.toggleEntry(item.habit.habit.id, DateTime.now());
    setState(() => _future = _load());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => setState(() => _future = _load()),
      child: FutureBuilder<List<_TodayItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return ListView(
              children: const [
                SizedBox(height: 120),
                Center(child: Text('Nenhum hábito programado para hoje.')),
              ],
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) => _TodayHabitCard(item: items[index], onToggle: _toggle),
          );
        },
      ),
    );
  }
}

class _TodayHabitCard extends StatelessWidget {
  final _TodayItem item;
  final ValueChanged<_TodayItem> onToggle;

  const _TodayHabitCard({required this.item, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final category = item.habit.category;
    final color = hexToColor(category.color);

    IconData statusIcon;
    Color statusColor;
    switch (item.status) {
      case HabitEntryStatus.done:
        statusIcon = Icons.check_circle;
        statusColor = AppColors.primaryBlue;
        break;
      case HabitEntryStatus.notDone:
        statusIcon = Icons.cancel;
        statusColor = Colors.red;
        break;
      default:
        statusIcon = Icons.radio_button_unchecked;
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.15), child: Icon(iconFor(category.icon), color: color)),
        title: Text(item.habit.habit.name),
        subtitle: Text(category.name),
        trailing: IconButton(
          iconSize: 32,
          icon: Icon(statusIcon, color: statusColor),
          onPressed: () => onToggle(item),
        ),
      ),
    );
  }
}
