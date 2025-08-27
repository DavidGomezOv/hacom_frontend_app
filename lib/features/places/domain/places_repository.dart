import 'package:dartz/dartz.dart';
import 'package:hacom_frontend_app/core/errors/server_failure.dart';
import 'package:hacom_frontend_app/features/places/domain/entities/places_response_entity.dart';

abstract class PlacesRepository {
  Future<Either<Failure, PlacesResponseEntity>> getPlaces({
    required int page,
    required int limit,
  });
}
