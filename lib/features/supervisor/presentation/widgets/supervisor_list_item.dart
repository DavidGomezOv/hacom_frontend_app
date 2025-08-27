import 'package:flutter/material.dart';

class SupervisorListItem extends StatelessWidget {
  const SupervisorListItem({
    super.key,
    required this.title,
    required this.description,
    required this.color,
  });

  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        child: ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          subtitle: Text(description),
          trailing: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: color),
          ),
        ),
      ),
    );
  }
}
