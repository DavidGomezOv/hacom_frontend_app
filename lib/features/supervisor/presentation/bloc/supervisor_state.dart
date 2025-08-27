part of 'supervisor_cubit.dart';

@freezed
class SupervisorState with _$SupervisorState {
  const factory SupervisorState.initial() = _Initial;

  const factory SupervisorState.loading() = _Loading;

  const factory SupervisorState.success({
    required List<VehicleEntity> vehicles,
    required int totalPages,
    @Default(0) int currentPage,
    @Default(false) bool isFetching,
  }) = _Success;

  const factory SupervisorState.failure({required String errorMessage}) = _Failure;
}
