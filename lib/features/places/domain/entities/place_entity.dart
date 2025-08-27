import 'package:freezed_annotation/freezed_annotation.dart';

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

  factory PlaceEntity.fromJson(Map<String, dynamic> json) => _$PlaceEntityFromJson(json);
}
