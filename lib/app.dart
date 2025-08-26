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
      providers: [BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>())],
      child: MaterialApp.router(
        title: 'My App',
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
