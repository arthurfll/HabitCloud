import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/db/habit_repository.dart';
import '../../core/icons/bootstrap_icon_map.dart';
import '../../core/models/habit_model.dart';
import '../../core/utils/color_utils.dart';
import 'habit_detail_screen.dart';
import 'widgets/habit_editor_dialog.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  Future<void> _create(BuildContext context) async {
    final scope = AppScope.of(context);
    final categories = await scope.categoryRepository.getAll();
    if (categories.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Crie uma categoria primeiro.')));
      }
      return;
    }

    if (!context.mounted) return;
    final result = await showHabitEditorDialog(context, categories: categories);
    if (result == null) return;
    await scope.habitRepository.create(
      name: result.name,
      categoryId: result.categoryId,
      frequencyType: result.frequencyType,
      intervalDays: result.intervalDays,
      dayOfMonth: result.dayOfMonth,
      dayOfWeek: result.dayOfWeek,
    );
  }

  String _frequencyLabel(HabitWithCategory h) {
    switch (h.habit.frequencyType) {
      case HabitFrequencyType.everyNDays:
        final interval = h.habit.intervalDays ?? 0;
        return interval <= 0 ? 'Todo dia' : 'A cada $interval dias';
      case HabitFrequencyType.dayOfMonth:
        return 'Todo dia ${h.habit.dayOfMonth} do mês';
      case HabitFrequencyType.dayOfWeek:
        const labels = ['Todo Domingo', 'Toda Segunda', 'Toda Terça', 'Toda Quarta', 'Toda Quinta', 'Toda Sexta', 'Todo Sábado'];
        return labels[h.habit.dayOfWeek ?? 0];
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.of(context).habitRepository;

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () => _create(context), child: const Icon(Icons.add)),
      body: StreamBuilder<List<HabitWithCategory>>(
        stream: repo.watchAll(),
        builder: (context, snapshot) {
          final habits = snapshot.data ?? const [];
          if (habits.isEmpty) {
            return const Center(child: Text('Nenhum hábito ainda. Toque em + para criar.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final h = habits[index];
              final color = hexToColor(h.category.color);
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.15),
                    child: Icon(iconFor(h.category.icon), color: color),
                  ),
                  title: Text(h.habit.name),
                  subtitle: Text(_frequencyLabel(h)),
                  trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => repo.delete(h.habit.id)),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => HabitDetailScreen(habitId: h.habit.id))),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
