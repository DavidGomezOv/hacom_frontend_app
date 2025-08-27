import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hacom_frontend_app/features/supervisor/presentation/bloc/supervisor_cubit.dart';
import 'package:hacom_frontend_app/shared/widgets/base_page.dart';

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
              final bool canFetchMore = currentPage <= totalPages;
              return NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (!isFetching &&
                      scrollInfo.metrics.pixels >= (scrollInfo.metrics.maxScrollExtent - 200) &&
                      canFetchMore) {
                    context.read<SupervisorCubit>().fetchVehicles();
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount: vehicles.length + (canFetchMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == vehicles.length) {
                      return const Padding(
                        padding: EdgeInsets.all(30),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final vehicle = vehicles[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: Colors.white,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text(vehicle.plate),
                          subtitle: Text(vehicle.label ?? ''),
                          trailing: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Color(int.parse('0xFF${vehicle.color}')),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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
