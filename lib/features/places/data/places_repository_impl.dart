import 'package:dartz/dartz.dart';
import 'package:hacom_frontend_app/core/errors/server_failure.dart';
import 'package:hacom_frontend_app/features/places/data/datasources/remote/places_remote_datasource.dart';
import 'package:hacom_frontend_app/features/places/domain/entities/places_response_entity.dart';
import 'package:hacom_frontend_app/features/places/domain/places_repository.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  final PlacesRemoteDatasource remoteDatasource;

  PlacesRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, PlacesResponseEntity>> getPlaces({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await remoteDatasource.getPlaces(page: page, limit: limit);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
