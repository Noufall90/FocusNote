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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isCompleted ? const Color.fromARGB(255, 198, 198, 198) : colorScheme.primary,
      ),
      child: Column(
        children: [
          
          // --- TILE UTAMA ---
          ListTile(
            title: Text(
              text,
              style: TextStyle(
                decoration: isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            leading: Checkbox(
              value: isCompleted,
              onChanged: onCheckboxChanged,
              checkColor: Colors.white,
              fillColor: WidgetStateProperty.all(colorScheme.secondary),
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

          // --- TILE KECIL TAMBAHAN (tidak berubah) ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: BoxDecoration(

              // ignore: deprecated_member_use
              color: colorScheme.secondaryContainer.withOpacity(0.4),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: const Text(
              "11 : 00 AM", 
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
