import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hacom_frontend_app/core/router/app_router.dart';
import 'package:hacom_frontend_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:hacom_frontend_app/features/dashboard/presentation/widgets/dashboard_item_button_widget.dart';
import 'package:hacom_frontend_app/shared/widgets/base_page.dart';
import 'package:hacom_frontend_app/shared/widgets/common_button.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) =>
          state.whenOrNull(logout: () => context.goNamed(AppRouter.loginRouteName)),
      child: BasePage(
        pageTitle: 'Welcome!',
        pageDescription: 'Please select what you want to do today.',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            DashboardItemButtonWidget(
              buttonTitle: 'Supervisor',
              buttonDescription: 'This is a short description of the supervisor menu.',
              onPressed: () => context.goNamed(AppRouter.supervisorRouteName),
            ),
            DashboardItemButtonWidget(
              buttonTitle: 'Notifications',
              buttonDescription: 'This is a short description of the supervisor menu.',
              onPressed: () {},
            ),
            DashboardItemButtonWidget(
              buttonTitle: 'Places',
              buttonDescription: 'This is a short description of the supervisor menu.',
              onPressed: () => context.goNamed(AppRouter.placesRouteName),
            ),
            Spacer(),
            DashboardItemButtonWidget(
              buttonTitle: 'Logout',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          Text(
                            'Attention!',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Are you sure you want to Logout?',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          SizedBox(height: 10),
                          CommonButton(
                            onPressed: () {
                              context.read<AuthCubit>().logout();
                            },
                            buttonLabel: 'Yes',
                            isOutlined: false,
                          ),
                          CommonButton(
                            onPressed: () {
                              context.pop();
                            },
                            buttonLabel: 'No',
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
