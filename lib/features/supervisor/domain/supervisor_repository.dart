import 'package:dartz/dartz.dart';
import 'package:hacom_frontend_app/core/errors/server_failure.dart';
import 'package:hacom_frontend_app/features/supervisor/domain/entities/vehicles_response_entity.dart';

abstract class SupervisorRepository {
  Future<Either<Failure, VehiclesResponseEntity>> getVehicles({
    required int page,
    required int limit,
  });
}
