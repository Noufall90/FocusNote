import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final String title;
  final Widget leading;
  final void Function()? onTap;
  final Widget? trailing;

  const DrawerTile({
    super.key,
    required this.title,
    required this.leading,
    required this.onTap,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: ListTile(
        leading: leading,
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 17,
          ),
        ),
        onTap: onTap,
        trailing: trailing,
      ),
    );
  }
}