import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_marker_entity.freezed.dart';

@freezed
abstract class MapMarkerEntity with _$MapMarkerEntity {
  const factory MapMarkerEntity({
    required int markerId,
    required String markerTitle,
    required String markerLabel,
    required double latitude,
    required double longitude,
  }) = _MapMarkerEntity;
}
