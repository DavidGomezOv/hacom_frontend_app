import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hacom_frontend_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:hacom_frontend_app/features/auth/presentation/login_page.dart';
import 'package:hacom_frontend_app/features/core/presentation/splash_page.dart';
import 'package:hacom_frontend_app/features/dashboard/presentation/dashboard_page.dart';

class AppRouter {
  static String get splashRoutePath => '/';

  static String get loginRoutePath => '/login';

  static String get loginRouteName => 'login';

  static String get dashboardRoutePath => '/dashboard';

  static String get dashboardRouteName => 'dashboard';

  static GoRouter generateRouter(BuildContext context) {
    return GoRouter(
      initialLocation: splashRoutePath,
      refreshListenable: _GoRouterRefreshStream(context.read<AuthCubit>().stream),
      redirect: (context, state) {
        final authState = context.read<AuthCubit>().state;

        return authState.maybeWhen(
          success: () => dashboardRoutePath,
          initial: () => loginRoutePath,
          failure: (_) => loginRoutePath,
          orElse: () => null,
        );
      },
      routes: [
        GoRoute(path: splashRoutePath, builder: (context, state) => const SplashPage()),
        GoRoute(
          path: loginRoutePath,
          name: loginRouteName,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: dashboardRoutePath,
          name: dashboardRouteName,
          builder: (context, state) => const DashboardPage(),
        ),
      ],
    );
  }
}

class _GoRouterRefreshStream<T> extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<T> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<T> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
