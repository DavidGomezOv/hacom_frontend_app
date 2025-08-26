import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hacom_frontend_app/core/router/app_router.dart';
import 'package:hacom_frontend_app/features/auth/presentation/bloc/auth_cubit.dart';

import 'core/di/injector.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //final getIt = GetIt.instance;
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>()..checkLoginStatus()),
      ],
      child: AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final router = AppRouter.generateRouter(context);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Hacom',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
