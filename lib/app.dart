import 'package:flutter/material.dart';
import 'core/config/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My App',
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
