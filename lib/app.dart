import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hacom_frontend_app/core/router/app_router.dart';
import 'package:hacom_frontend_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:hacom_frontend_app/features/places/presentation/bloc/places_cubit.dart';
import 'package:hacom_frontend_app/features/supervisor/presentation/bloc/supervisor_cubit.dart';

import 'core/di/injector.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>()..checkLoginStatus()),
        BlocProvider<SupervisorCubit>(create: (context) => getIt<SupervisorCubit>()),
        BlocProvider<PlacesCubit>(create: (context) => getIt<PlacesCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Hacom',
        routerConfig: AppRouter.generateRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
