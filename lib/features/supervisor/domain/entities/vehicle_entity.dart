import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hacom_frontend_app/features/map/domain/entities/map_marker_entity.dart';

part 'vehicle_entity.freezed.dart';

part 'vehicle_entity.g.dart';

@freezed
abstract class VehicleEntity with _$VehicleEntity {
  const factory VehicleEntity({
    required int id,
    required String plate,
    required String color,
    String? label,
    double? latitude,
    double? longitude,
  }) = _VehicleEntity;

  factory VehicleEntity.fromJson(Map<String, dynamic> json) =>
      _$VehicleEntityFromJson(json);
}

extension VehicleEntityExtension on VehicleEntity {
  MapMarkerEntity get toMapMarkerEntity => MapMarkerEntity(
    markerId: id,
    markerTitle: plate,
    markerLabel: label ?? '',
    latitude: latitude ?? 0,
    longitude: longitude ?? 0,
  );
}
