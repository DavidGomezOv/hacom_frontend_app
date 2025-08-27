import 'package:freezed_annotation/freezed_annotation.dart';

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

  factory VehicleEntity.fromJson(Map<String, dynamic> json) => _$VehicleEntityFromJson(json);
}
