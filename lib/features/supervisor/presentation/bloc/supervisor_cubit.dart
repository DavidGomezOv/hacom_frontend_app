import 'package:hacom_frontend_app/features/supervisor/domain/entities/vehicle_entity.dart';
import 'package:hacom_frontend_app/features/supervisor/domain/supervisor_repository.dart';
import 'package:hacom_frontend_app/shared/cubit/paginated_cubit.dart';
import 'package:hacom_frontend_app/shared/cubit/paginated_response.dart';

class SupervisorCubit extends PaginatedCubit<VehicleEntity> {
  final SupervisorRepository repository;

  SupervisorCubit({required this.repository})
    : super(
        fetchPage: (page, limit) async {
          final result = await repository.getVehicles(page: page, limit: limit);

          return result.fold(
            (failure) => throw Exception(failure),
            (response) =>
                PaginatedResponse(items: response.vehicles, totalPages: response.totalPages),
          );
        },
      );
}
