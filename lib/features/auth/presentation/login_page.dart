import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hacom_frontend_app/features/auth/presentation/bloc/auth_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return state.when(
            initial: () => TextButton(
              onPressed: () => context.read<AuthCubit>().login(accountName: '', phoneNumber: 0),
              child: Text('LOGIN'),
            ),
            loading: () => CircularProgressIndicator(),
            success: () => Text('SUCCESS!!!'),
            failure: (errorMessage) => Text('FAILURE! $errorMessage'),
          );
        },
      ),
    ),
  );
}
