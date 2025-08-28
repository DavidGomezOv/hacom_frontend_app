import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hacom_frontend_app/shared/widgets/common_button.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key, required this.onPrimaryButtonPressed});

  final Function() onPrimaryButtonPressed;

  @override
  Widget build(BuildContext context) => AlertDialog(
    backgroundColor: Colors.white,
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        Text(
          'Attention!',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text('Are you sure you want to Logout?', style: Theme.of(context).textTheme.bodyLarge),
        SizedBox(height: 10),
        CommonButton(onPressed: onPrimaryButtonPressed, buttonLabel: 'Yes', isOutlined: false),
        CommonButton(onPressed: () => context.pop(), buttonLabel: 'No'),
      ],
    ),
  );
}
