import 'package:hacom_frontend_app/features/places/domain/entities/places_response_entity.dart';

abstract class PlacesRemoteDatasource {
  Future<PlacesResponseEntity> getPlaces({
    required int page,
    required int limit,
  });
}
