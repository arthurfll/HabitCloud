import 'package:flutter/material.dart';

import '../../../core/db/app_database.dart';
import '../../../core/models/habit_model.dart';

class HabitEditorResult {
  final String name;
  final int categoryId;
  final int frequencyType;
  final int? intervalDays;
  final int? dayOfMonth;
  final int? dayOfWeek;

  const HabitEditorResult({
    required this.name,
    required this.categoryId,
    required this.frequencyType,
    this.intervalDays,
    this.dayOfMonth,
    this.dayOfWeek,
  });
}

const _weekdayLabels = ['Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'];

Future<HabitEditorResult?> showHabitEditorDialog(
  BuildContext context, {
  required List<CategoriesTableData> categories,
  String? initialName,
  int? initialCategoryId,
}) {
  return showDialog<HabitEditorResult>(
    context: context,
    builder: (context) =>
        _HabitEditorDialog(categories: categories, initialName: initialName, initialCategoryId: initialCategoryId),
  );
}

class _HabitEditorDialog extends StatefulWidget {
  final List<CategoriesTableData> categories;
  final String? initialName;
  final int? initialCategoryId;

  const _HabitEditorDialog({required this.categories, this.initialName, this.initialCategoryId});

  @override
  State<_HabitEditorDialog> createState() => _HabitEditorDialogState();
}

class _HabitEditorDialogState extends State<_HabitEditorDialog> {
  late final _nameController = TextEditingController(text: widget.initialName);
  late int? _categoryId = widget.initialCategoryId ?? (widget.categories.isEmpty ? null : widget.categories.first.id);
  int _frequencyType = HabitFrequencyType.everyNDays;
  int _intervalDays = 0;
  int _dayOfMonth = 1;
  int _dayOfWeek = 1;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialName == null ? 'Novo hábito' : 'Editar hábito'),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(controller: _nameController, maxLength: 50, decoration: const InputDecoration(labelText: 'Nome')),
              const SizedBox(height: 8),
              if (widget.categories.isEmpty)
                const Text('Crie uma categoria primeiro.')
              else
                DropdownButtonFormField<int>(
                  initialValue: _categoryId,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  items: widget.categories
                      .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                      .toList(),
                  onChanged: (v) => setState(() => _categoryId = v),
                ),
              const SizedBox(height: 12),
              const Text('Frequência'),
              RadioGroup<int>(
                groupValue: _frequencyType,
                onChanged: (v) => setState(() => _frequencyType = v!),
                child: Column(
                  children: const [
                    RadioListTile<int>(
                      dense: true,
                      title: Text('A cada N dias (0 = todo dia)'),
                      value: HabitFrequencyType.everyNDays,
                    ),
                    RadioListTile<int>(
                      dense: true,
                      title: Text('Dia fixo do mês'),
                      value: HabitFrequencyType.dayOfMonth,
                    ),
                    RadioListTile<int>(
                      dense: true,
                      title: Text('Dia fixo da semana'),
                      value: HabitFrequencyType.dayOfWeek,
                    ),
                  ],
                ),
              ),
              if (_frequencyType == HabitFrequencyType.everyNDays)
                Slider(
                  value: _intervalDays.toDouble(),
                  min: 0,
                  max: 30,
                  divisions: 30,
                  label: _intervalDays == 0 ? 'Todo dia' : 'A cada $_intervalDays dias',
                  onChanged: (v) => setState(() => _intervalDays = v.round()),
                ),
              if (_frequencyType == HabitFrequencyType.dayOfMonth)
                Slider(
                  value: _dayOfMonth.toDouble(),
                  min: 1,
                  max: 31,
                  divisions: 30,
                  label: 'Dia $_dayOfMonth',
                  onChanged: (v) => setState(() => _dayOfMonth = v.round()),
                ),
              if (_frequencyType == HabitFrequencyType.dayOfWeek)
                DropdownButtonFormField<int>(
                  initialValue: _dayOfWeek,
                  items: List.generate(
                    7,
                    (i) => DropdownMenuItem(value: i, child: Text(_weekdayLabels[i])),
                  ),
                  onChanged: (v) => setState(() => _dayOfWeek = v!),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: _categoryId == null
              ? null
              : () {
                  final name = _nameController.text.trim();
                  if (name.isEmpty) return;
                  Navigator.of(context).pop(
                    HabitEditorResult(
                      name: name,
                      categoryId: _categoryId!,
                      frequencyType: _frequencyType,
                      intervalDays: _frequencyType == HabitFrequencyType.everyNDays ? _intervalDays : null,
                      dayOfMonth: _frequencyType == HabitFrequencyType.dayOfMonth ? _dayOfMonth : null,
                      dayOfWeek: _frequencyType == HabitFrequencyType.dayOfWeek ? _dayOfWeek : null,
                    ),
                  );
                },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
