import 'package:flutter/material.dart';

class DashboardItemButtonWidget extends StatelessWidget {
  const DashboardItemButtonWidget({
    super.key,
    required this.buttonTitle,
    this.buttonDescription,
    required this.onPressed,
  });

  final String buttonTitle;
  final String? buttonDescription;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              buttonTitle,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (buttonDescription != null && buttonDescription!.isNotEmpty)
              Text(buttonDescription!),
          ],
        ),
      ),
    );
  }
}
