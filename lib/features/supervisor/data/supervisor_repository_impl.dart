import 'package:dartz/dartz.dart';
import 'package:hacom_frontend_app/core/errors/server_failure.dart';
import 'package:hacom_frontend_app/features/supervisor/data/datasources/remote/supervisor_remote_datasource.dart';
import 'package:hacom_frontend_app/features/supervisor/domain/entities/vehicles_response_entity.dart';
import 'package:hacom_frontend_app/features/supervisor/domain/supervisor_repository.dart';

class SupervisorRepositoryImpl implements SupervisorRepository {
  final SupervisorRemoteDatasource remoteDatasource;

  SupervisorRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, VehiclesResponseEntity>> getVehicles({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await remoteDatasource.getVehicles(page: page, limit: limit);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
