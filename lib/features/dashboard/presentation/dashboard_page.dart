import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hacom_frontend_app/core/router/app_router.dart';
import 'package:hacom_frontend_app/features/auth/presentation/bloc/auth_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.whenOrNull(logout: () => context.goNamed(AppRouter.loginRouteName));
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ElevatedButton(onPressed: () {}, child: Text("Button 1")),
                ElevatedButton(onPressed: () {}, child: Text("Button 2")),
                ElevatedButton(onPressed: () {}, child: Text("Button 3")),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().logout();
                  },
                  child: Text("Logout"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
