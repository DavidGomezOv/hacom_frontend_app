import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hacom_frontend_app/core/router/app_router.dart';
import 'package:hacom_frontend_app/features/supervisor/domain/entities/vehicle_entity.dart';
import 'package:hacom_frontend_app/features/supervisor/presentation/bloc/supervisor_cubit.dart';
import 'package:hacom_frontend_app/shared/cubit/paginated_cubit.dart';
import 'package:hacom_frontend_app/shared/widgets/base_page.dart';
import 'package:hacom_frontend_app/shared/widgets/common_button.dart';
import 'package:hacom_frontend_app/shared/widgets/common_list_item.dart';

class SupervisorPage extends StatelessWidget {
  const SupervisorPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SupervisorCubit>().fetch();

    return BasePage(
      pageTitle: 'Supervisor',
      pageDescription: 'Short description of supervisor module.',
      showBackButton: true,
      leading: IconButton(
        icon: Icon(Icons.refresh_outlined),
        visualDensity: VisualDensity.compact,
        onPressed: () => context.read<SupervisorCubit>().fetch(refresh: true),
      ),
      content: BlocBuilder<SupervisorCubit, PaginatedState<VehicleEntity>>(
        builder: (context, state) => state.maybeWhen(
          failure: (errorMessage) => Center(child: Text('Error: $errorMessage')),
          success: (items, currentPage, totalPages, isFetching) {
            final canFetchMore = currentPage < totalPages;
            return Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                CommonButton(
                  onPressed: () => context.pushNamed(
                    AppRouter.mapRouteName,
                    extra: items.map((vehicle) => vehicle.toMapMarkerEntity).toList(),
                  ),
                  buttonLabel: 'View all on Map',
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (!isFetching &&
                          scrollInfo.metrics.pixels >= (scrollInfo.metrics.maxScrollExtent - 200) &&
                          canFetchMore) {
                        context.read<SupervisorCubit>().fetch();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      itemCount: items.length + (canFetchMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == items.length) {
                          return const Padding(
                            padding: EdgeInsets.all(30),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final vehicle = items[index];
                        return CommonListItem(
                          title: vehicle.plate,
                          description: vehicle.label ?? '',
                          trailing: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Color(int.parse('0xFF${vehicle.color}')),
                            ),
                          ),
                          onTap: () => context.pushNamed(
                            AppRouter.mapRouteName,
                            extra: [vehicle.toMapMarkerEntity],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
          orElse: () => Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
