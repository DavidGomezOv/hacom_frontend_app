import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hacom_frontend_app/shared/cubit/paginated_response.dart';

part 'paginated_state.dart';

part 'paginated_cubit.freezed.dart';

typedef FetchPage<T> = Future<PaginatedResponse<T>> Function(int page, int limit);

class PaginatedCubit<T> extends Cubit<PaginatedState<T>> {
  final FetchPage<T> fetchPage;
  final int limit;

  PaginatedCubit({required this.fetchPage, this.limit = 10}) : super(PaginatedState.initial());

  Future<void> fetch({bool refresh = false}) async {
    if (refresh) {
      emit(PaginatedState.loading());
    } else {
      state.whenOrNull(
        success: (items, currentPage, totalPages, isFetching) {
          emit(
            PaginatedState.success(
              items: items,
              currentPage: currentPage,
              totalPages: totalPages,
              isFetching: true,
            ),
          );
        },
      );
    }

    final pageToFetch = refresh
        ? 1
        : state.maybeWhen(
            success: (items, currentPage, totalPages, isFetching) => currentPage + 1,
            orElse: () => 1,
          );

    try {
      final response = await fetchPage(pageToFetch, limit);

      state.maybeWhen(
        success: (items, currentPage, totalPages, isFetching) {
          emit(
            PaginatedState.success(
              items: [...items, ...response.items],
              currentPage: pageToFetch,
              totalPages: response.totalPages,
              isFetching: false,
            ),
          );
        },
        orElse: () {
          emit(
            PaginatedState.success(
              items: response.items,
              currentPage: pageToFetch,
              totalPages: response.totalPages,
              isFetching: false,
            ),
          );
        },
      );
    } catch (e) {
      emit(PaginatedState.failure(errorMessage: e.toString()));
    }
  }
}
