import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hacom_frontend_app/features/supervisor/domain/entities/vehicle_entity.dart';

part 'vehicles_response_entity.freezed.dart';

part 'vehicles_response_entity.g.dart';

@freezed
abstract class VehiclesResponseEntity with _$VehiclesResponseEntity {
  const factory VehiclesResponseEntity({
    required int page,
    required int total,
    required int totalPages,
    @JsonKey(name: "data") @Default([]) List<VehicleEntity> vehicles,
  }) = _VehiclesResponseEntity;

  factory VehiclesResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$VehiclesResponseEntityFromJson(json);
}
