import 'package:hacom_frontend_app/features/places/domain/entities/place_entity.dart';
import 'package:hacom_frontend_app/features/places/domain/places_repository.dart';
import 'package:hacom_frontend_app/shared/cubit/paginated_cubit.dart';
import 'package:hacom_frontend_app/shared/cubit/paginated_response.dart';

class PlacesCubit extends PaginatedCubit<PlaceEntity> {
  final PlacesRepository repository;

  PlacesCubit({required this.repository})
    : super(
        fetchPage: (page, limit) async {
          final result = await repository.getPlaces(page: page, limit: limit);

          return result.fold(
            (failure) => throw Exception(failure),
            (response) =>
                PaginatedResponse(items: response.places, totalPages: response.totalPages),
          );
        },
      );
}
