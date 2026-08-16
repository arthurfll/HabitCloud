import 'package:flutter/material.dart';

import '../../../core/icons/bootstrap_icon_map.dart';
import '../../../core/models/category_options.dart';
import '../../../core/utils/color_utils.dart';

class CategoryEditorResult {
  final String name;
  final String icon;
  final String color;

  const CategoryEditorResult({required this.name, required this.icon, required this.color});
}

Future<CategoryEditorResult?> showCategoryEditorDialog(
  BuildContext context, {
  String? initialName,
  String? initialIcon,
  String? initialColor,
}) {
  return showDialog<CategoryEditorResult>(
    context: context,
    builder: (context) => _CategoryEditorDialog(initialName: initialName, initialIcon: initialIcon, initialColor: initialColor),
  );
}

class _CategoryEditorDialog extends StatefulWidget {
  final String? initialName;
  final String? initialIcon;
  final String? initialColor;

  const _CategoryEditorDialog({this.initialName, this.initialIcon, this.initialColor});

  @override
  State<_CategoryEditorDialog> createState() => _CategoryEditorDialogState();
}

class _CategoryEditorDialogState extends State<_CategoryEditorDialog> {
  late final _nameController = TextEditingController(text: widget.initialName);
  late String _icon = widget.initialIcon ?? CategoryOptions.icons.first;
  late String _color = widget.initialColor ?? CategoryOptions.colors.first;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialName == null ? 'Nova categoria' : 'Editar categoria'),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                maxLength: 50,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              const SizedBox(height: 8),
              const Text('Ícone'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: CategoryOptions.icons.map((icon) {
                  final selected = icon == _icon;
                  return GestureDetector(
                    onTap: () => setState(() => _icon = icon),
                    child: CircleAvatar(
                      backgroundColor: selected ? hexToColor(_color) : Colors.grey.shade200,
                      child: Icon(iconFor(icon), color: selected ? Colors.white : Colors.black54),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Cor'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: CategoryOptions.colors.map((color) {
                  final selected = color == _color;
                  return GestureDetector(
                    onTap: () => setState(() => _color = color),
                    child: CircleAvatar(
                      backgroundColor: hexToColor(color),
                      child: selected ? const Icon(Icons.check, color: Colors.white) : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isEmpty) return;
            Navigator.of(context).pop(CategoryEditorResult(name: name, icon: _icon, color: _color));
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
