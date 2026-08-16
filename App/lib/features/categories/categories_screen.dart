import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/db/app_database.dart';
import '../../core/icons/bootstrap_icon_map.dart';
import '../../core/models/category_options.dart';
import '../../core/utils/color_utils.dart';
import 'widgets/category_editor_dialog.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  Future<void> _create(BuildContext context) async {
    final repo = AppScope.of(context).categoryRepository;
    final existing = await repo.getAll();
    if (existing.length >= CategoryOptions.maxCategoriesPerUser) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Limite de ${CategoryOptions.maxCategoriesPerUser} categorias atingido.')));
      }
      return;
    }

    if (!context.mounted) return;
    final result = await showCategoryEditorDialog(context);
    if (result == null) return;
    await repo.create(name: result.name, icon: result.icon, color: result.color);
  }

  Future<void> _edit(BuildContext context, CategoriesTableData category) async {
    final result = await showCategoryEditorDialog(
      context,
      initialName: category.name,
      initialIcon: category.icon,
      initialColor: category.color,
    );
    if (result == null) return;
    if (context.mounted) {
      await AppScope.of(
        context,
      ).categoryRepository.update(category.id, name: result.name, icon: result.icon, color: result.color);
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.of(context).categoryRepository;

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () => _create(context), child: const Icon(Icons.add)),
      body: StreamBuilder<List<CategoriesTableData>>(
        stream: repo.watchAll(),
        builder: (context, snapshot) {
          final categories = snapshot.data ?? const [];
          if (categories.isEmpty) {
            return const Center(child: Text('Nenhuma categoria ainda. Toque em + para criar.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final color = hexToColor(category.color);
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.15),
                    child: Icon(iconFor(category.icon), color: color),
                  ),
                  title: Text(category.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _edit(context, category)),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => repo.delete(category.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
