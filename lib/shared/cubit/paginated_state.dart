part of 'paginated_cubit.dart';

@freezed
class PaginatedState<T> with _$PaginatedState<T> {
  const factory PaginatedState.initial() = _Initial;

  const factory PaginatedState.loading() = _Loading;

  const factory PaginatedState.success({
    required List<T> items,
    required int currentPage,
    required int totalPages,
    @Default(false) bool isFetching,
  }) = _Success;

  const factory PaginatedState.failure({required String errorMessage}) =
      _Failure;
}
