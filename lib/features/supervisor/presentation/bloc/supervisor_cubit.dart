import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hacom_frontend_app/features/supervisor/domain/entities/vehicle_entity.dart';
import 'package:hacom_frontend_app/features/supervisor/domain/supervisor_repository.dart';

part 'supervisor_state.dart';

part 'supervisor_cubit.freezed.dart';

class SupervisorCubit extends Cubit<SupervisorState> {
  final SupervisorRepository repository;

  SupervisorCubit({required this.repository}) : super(const SupervisorState.initial());

  Future<void> fetchVehicles({bool refresh = false}) async {
    if (refresh) {
      emit(SupervisorState.loading());
    } else {
      state.whenOrNull(
        success: (vehicles, totalPages, currentPage, isFetching) {
          emit(
            SupervisorState.success(
              vehicles: vehicles,
              totalPages: totalPages,
              currentPage: currentPage,
              isFetching: true,
            ),
          );
        },
      );
    }

    final pageToFetch = refresh
        ? 1
        : state.maybeWhen(
            success: (vehicles, totalPages, currentPage, isFetching) => currentPage + 1,
            orElse: () => 1,
          );

    final response = await repository.getVehicles(page: pageToFetch, limit: 10);

    response.fold((l) => emit(SupervisorState.failure(errorMessage: 'Error fetching vehicles')), (
      result,
    ) {
      if (refresh) {
        emit(
          SupervisorState.success(
            vehicles: result.vehicles,
            totalPages: result.totalPages,
            currentPage: pageToFetch,
            isFetching: false,
          ),
        );
        return;
      }
      state.maybeWhen(
        success: (vehicles, totalPages, currentPage, isFetching) {
          emit(
            SupervisorState.success(
              vehicles: [...vehicles, ...result.vehicles],
              totalPages: result.totalPages,
              currentPage: pageToFetch,
              isFetching: false,
            ),
          );
        },
        orElse: () {
          emit(
            SupervisorState.success(
              vehicles: result.vehicles,
              totalPages: result.totalPages,
              currentPage: pageToFetch,
              isFetching: false,
            ),
          );
        },
      );
    });
  }
}
