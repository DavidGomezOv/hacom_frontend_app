import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BasePage extends StatelessWidget {
  const BasePage({
    super.key,
    required this.pageTitle,
    this.pageDescription,
    this.showBackButton = false,
    this.leading,
    required this.content,
  });

  final String pageTitle;
  final String? pageDescription;
  final bool showBackButton;
  final Widget? leading;
  final Widget content;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showBackButton)
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => context.pop(),
                  ),
                Text(
                  pageTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                if (leading != null) leading!,
              ],
            ),
            if (pageDescription != null)
              Text(
                pageDescription!,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
            SizedBox(height: 30),
            Flexible(child: content),
          ],
        ),
      ),
    ),
  );
}
