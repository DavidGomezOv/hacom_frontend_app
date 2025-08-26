import 'package:go_router/go_router.dart';
import 'package:hacom_frontend_app/features/auth/presentation/login_page.dart';

class AppRouter {
  static String get loginRoutePath => '/login';

  static String get loginRouteName => 'login';

  static GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: loginRoutePath,
        name: loginRouteName,
        builder: (context, state) => const LoginPage(),
      ),
    ],
  );
}
