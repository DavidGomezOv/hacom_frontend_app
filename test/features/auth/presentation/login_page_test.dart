import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hacom_frontend_app/features/auth/presentation/login_page.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hacom_frontend_app/core/router/app_router.dart';
import 'package:hacom_frontend_app/features/auth/presentation/bloc/auth_cubit.dart';

class MockAuthCubit extends Mock implements AuthCubit {}

class FakeAuthState extends Fake implements AuthState {}

void main() {
  late MockAuthCubit mockAuthCubit;

  setUpAll(() {
    registerFallbackValue(FakeAuthState());
  });

  setUp(() {
    mockAuthCubit = MockAuthCubit();
    when(() => mockAuthCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget makeTestableWidget(Widget child) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', name: AppRouter.loginRouteName, builder: (_, __) => child),
        GoRoute(
          path: AppRouter.dashboardRoutePath,
          name: AppRouter.dashboardRouteName,
          builder: (_, __) => const Scaffold(body: Text('DashboardPage')),
        ),
      ],
    );

    return MaterialApp.router(routerConfig: router);
  }

  group('LoginPage Widget Tests', () {
    testWidgets('renders initial UI correctly', (tester) async {
      when(() => mockAuthCubit.state).thenReturn(const AuthState.initial());

      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: mockAuthCubit,
          child: makeTestableWidget(const LoginPage()),
        ),
      );

      expect(find.text('LIVETrack'), findsOneWidget);
      expect(find.text('Personal and Delivery Management'), findsOneWidget);
      expect(find.text('Access'), findsOneWidget);
    });

    testWidgets('shows loading indicator when state is loading', (tester) async {
      when(() => mockAuthCubit.state).thenReturn(const AuthState.loading());

      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: mockAuthCubit,
          child: makeTestableWidget(const LoginPage()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('navigates to dashboard on success state', (tester) async {
      when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(AuthState.success()));
      when(() => mockAuthCubit.state).thenReturn(const AuthState.success());

      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: mockAuthCubit,
          child: makeTestableWidget(const LoginPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('DashboardPage'), findsOneWidget);
    });

    testWidgets('shows SnackBar on failure state', (tester) async {
      when(
        () => mockAuthCubit.stream,
      ).thenAnswer((_) => Stream.value(const AuthState.failure(errorMessage: 'Wrong credentials')));
      when(
        () => mockAuthCubit.state,
      ).thenReturn(const AuthState.failure(errorMessage: 'Wrong credentials'));

      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: mockAuthCubit,
          child: makeTestableWidget(const LoginPage()),
        ),
      );

      await tester.pump();

      expect(find.text('Login failed: Wrong credentials'), findsOneWidget);
    });

    testWidgets('taps Access button calls cubit.login when form is valid', (tester) async {
      when(() => mockAuthCubit.state).thenReturn(const AuthState.initial());
      when(
        () => mockAuthCubit.login(
          accountName: any(named: 'accountName'),
          phoneNumber: any(named: 'phoneNumber'),
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: mockAuthCubit,
          child: makeTestableWidget(const LoginPage()),
        ),
      );

      final accountField = find.byWidgetPredicate(
        (widget) => widget is TextField && widget.decoration?.hintText == 'Account Name',
      );
      await tester.enterText(accountField, 'myaccount');
      final phoneField = find.byWidgetPredicate(
        (widget) => widget is TextField && widget.decoration?.hintText == 'Phone Number',
      );
      await tester.enterText(phoneField, '12345678');

      await tester.tap(find.text('Access'));
      await tester.pump();

      verify(
        () => mockAuthCubit.login(accountName: 'myaccount', phoneNumber: '12345678'),
      ).called(1);
    });

    testWidgets('taps Access button without filling the form shows error messages', (tester) async {
      when(() => mockAuthCubit.state).thenReturn(const AuthState.initial());
      when(
        () => mockAuthCubit.login(
          accountName: any(named: 'accountName'),
          phoneNumber: any(named: 'phoneNumber'),
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: mockAuthCubit,
          child: makeTestableWidget(const LoginPage()),
        ),
      );

      await tester.tap(find.text('Access'));
      await tester.pump();

      expect(find.text('Enter a valid Account Name'), findsOneWidget);
      expect(find.text('Enter a valid Phone Number'), findsOneWidget);
    });
  });
}
