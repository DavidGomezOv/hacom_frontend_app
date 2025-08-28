import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hacom_frontend_app/features/map/domain/entities/map_marker_entity.dart';

part 'place_entity.freezed.dart';

part 'place_entity.g.dart';

@freezed
abstract class PlaceEntity with _$PlaceEntity {
  const factory PlaceEntity({
    required int id,
    required String name,
    required String description,
    required int phone,
    double? latitude,
    double? longitude,
  }) = _PlaceEntity;

  factory PlaceEntity.fromJson(Map<String, dynamic> json) =>
      _$PlaceEntityFromJson(json);
}

extension PlaceEntityExtension on PlaceEntity {
  MapMarkerEntity get toMapMarkerEntity => MapMarkerEntity(
    markerId: id,
    markerTitle: name,
    markerLabel: description,
    latitude: latitude ?? 0,
    longitude: longitude ?? 0,
  );
}
