import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function()? onEditPressed;
  final void Function()? onDeletePressed;
  final ValueChanged<bool?> onCheckboxChanged;

  const TaskTile({
    super.key,
    required this.text,
    required this.isCompleted,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(
            decoration:
                isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        leading: Checkbox(
          value: isCompleted,
          onChanged: onCheckboxChanged,
          checkColor: Colors.white, // warna tanda centang
          fillColor: WidgetStateProperty.all(
            Theme.of(context).colorScheme.secondary,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onEditPressed,
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: onDeletePressed,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
