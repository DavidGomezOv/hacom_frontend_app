import 'package:flutter/material.dart';

class CommonListItem extends StatelessWidget {
  const CommonListItem({
    super.key,
    required this.title,
    required this.description,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String description;
  final Widget? trailing;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        child: ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          subtitle: Text(description),
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }
}
