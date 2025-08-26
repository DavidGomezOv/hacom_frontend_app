import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hacom_frontend_app/core/router/app_router.dart';
import 'package:hacom_frontend_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:hacom_frontend_app/features/auth/presentation/widgets/login_text_form_field_widget.dart';
import 'package:hacom_frontend_app/shared/utils/form_validators.dart';
import 'package:hacom_frontend_app/shared/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final accountController = TextEditingController();
    final phoneController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            success: () => context.goNamed(AppRouter.dashboardRouteName),
            failure: (errorMessage) => ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Login failed: $errorMessage"))),
          );
        },
        builder: (context, state) {
          final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  Text(
                    'LIVETrack',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text('Personal and Delivery Management'),
                  SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 20,
                      children: [
                        LoginTextFormFieldWidget(
                          controller: accountController,
                          hintText: 'Account Name',
                          validator: (value) => FormValidators.commonValidator(
                            value,
                            'Enter a valid Account Name',
                            minLength: 4,
                            minLengthErrorMessage: 'Account Name should be 4 digits length minimum',
                          ),
                        ),
                        LoginTextFormFieldWidget(
                          controller: phoneController,
                          hintText: 'Phone Number',
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          maxLength: 8,
                          validator: (value) => FormValidators.commonValidator(
                            value,
                            'Enter a valid Phone Number',
                            minLength: 8,
                            minLengthErrorMessage: 'Phone Number should be 8 digits length',
                          ),
                        ),
                        CustomButton(
                          isLoading: isLoading,
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    context.read<AuthCubit>().login(
                                      accountName: accountController.text,
                                      phoneNumber: phoneController.text,
                                    );
                                  }
                                },
                          buttonLabel: 'Access',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
