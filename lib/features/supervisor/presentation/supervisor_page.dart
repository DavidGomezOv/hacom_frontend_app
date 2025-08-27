import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hacom_frontend_app/features/supervisor/domain/entities/vehicle_entity.dart';
import 'package:hacom_frontend_app/features/supervisor/presentation/bloc/supervisor_cubit.dart';
import 'package:hacom_frontend_app/features/supervisor/presentation/widgets/supervisor_list_item.dart';
import 'package:hacom_frontend_app/shared/widgets/base_page.dart';
import 'package:hacom_frontend_app/shared/widgets/infinite_scroll_list_with_pagination.dart';

class SupervisorPage extends StatelessWidget {
  const SupervisorPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SupervisorCubit>().fetchVehicles();

    return BasePage(
      pageTitle: 'Supervisor',
      pageDescription: 'Short description of supervisor module.',
      showBackButton: true,
      leading: IconButton(
        icon: Icon(Icons.refresh_outlined),
        visualDensity: VisualDensity.compact,
        onPressed: () => context.read<SupervisorCubit>().fetchVehicles(refresh: true),
      ),
      content: BlocBuilder<SupervisorCubit, SupervisorState>(
        builder: (context, state) {
          return state.maybeWhen(
            success: (vehicles, totalPages, currentPage, isFetching) {
              return InfiniteScrollListWithPagination<VehicleEntity>(
                items: vehicles,
                isFetching: isFetching,
                canFetchMore: currentPage < totalPages,
                onFetchMore: () => context.read<SupervisorCubit>().fetchVehicles(),
                itemBuilder: (context, vehicle) => SupervisorListItem(
                  title: vehicle.plate,
                  description: vehicle.label ?? '',
                  color: Color(int.parse('0xFF${vehicle.color}')),
                ),
              );
            },
            failure: (error) => Center(child: Text("Error: $error")),
            orElse: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
