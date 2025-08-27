import 'package:go_router/go_router.dart';
import 'package:hacom_frontend_app/features/auth/presentation/login_page.dart';
import 'package:hacom_frontend_app/features/core/presentation/splash_page.dart';
import 'package:hacom_frontend_app/features/dashboard/presentation/dashboard_page.dart';
import 'package:hacom_frontend_app/features/places/presentation/places_page.dart';
import 'package:hacom_frontend_app/features/supervisor/presentation/supervisor_page.dart';

class AppRouter {
  static String get splashRoutePath => '/';

  static String get loginRoutePath => '/login';

  static String get loginRouteName => 'login';

  static String get dashboardRoutePath => '/dashboard';

  static String get dashboardRouteName => 'dashboard';

  static String get supervisorRoutePath => '/supervisor';

  static String get supervisorRouteName => 'supervisor';

  static String get placesRoutePath => '/places';

  static String get placesRouteName => 'places';

  static GoRouter generateRouter = GoRouter(
    initialLocation: splashRoutePath,
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
        routes: [
          GoRoute(
            path: supervisorRoutePath,
            name: supervisorRouteName,
            builder: (context, state) => const SupervisorPage(),
          ),
          GoRoute(
            path: placesRoutePath,
            name: placesRouteName,
            builder: (context, state) => const PlacesPage(),
          ),
        ],
      ),
    ],
  );
}
