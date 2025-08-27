import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hacom_frontend_app/features/places/domain/entities/place_entity.dart';

part 'places_response_entity.freezed.dart';

part 'places_response_entity.g.dart';

@freezed
abstract class PlacesResponseEntity with _$PlacesResponseEntity {
  const factory PlacesResponseEntity({
    required int page,
    required int total,
    required int totalPages,
    @JsonKey(name: "data") @Default([]) List<PlaceEntity> places,
  }) = _PlacesResponseEntity;

  factory PlacesResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$PlacesResponseEntityFromJson(json);
}
