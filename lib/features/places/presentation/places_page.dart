import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hacom_frontend_app/core/router/app_router.dart';
import 'package:hacom_frontend_app/features/places/domain/entities/place_entity.dart';
import 'package:hacom_frontend_app/features/places/presentation/bloc/places_cubit.dart';
import 'package:hacom_frontend_app/shared/cubit/paginated_cubit.dart';
import 'package:hacom_frontend_app/shared/widgets/base_page.dart';
import 'package:hacom_frontend_app/shared/widgets/common_button.dart';
import 'package:hacom_frontend_app/shared/widgets/common_list_item.dart';

class PlacesPage extends StatelessWidget {
  const PlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<PlacesCubit>().fetch();

    return BasePage(
      pageTitle: 'Places',
      pageDescription: 'Short description of places module.',
      showBackButton: true,
      leading: IconButton(
        icon: Icon(Icons.refresh_outlined),
        onPressed: () => context.read<PlacesCubit>().fetch(refresh: true),
      ),
      content: BlocBuilder<PlacesCubit, PaginatedState<PlaceEntity>>(
        builder: (context, state) => state.maybeWhen(
          failure: (errorMessage) => Center(child: Text('Error: $errorMessage')),
          success: (items, currentPage, totalPages, isFetching) {
            final canFetchMore = currentPage < totalPages;
            return Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                CommonButton(
                  onPressed: () => context.pushNamed(
                    AppRouter.mapRouteName,
                    extra: items.map((place) => place.toMapMarkerEntity).toList(),
                  ),
                  buttonLabel: 'View all on Map',
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (!isFetching &&
                          scrollInfo.metrics.pixels >= (scrollInfo.metrics.maxScrollExtent - 200) &&
                          canFetchMore) {
                        context.read<PlacesCubit>().fetch();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      itemCount: items.length + (canFetchMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == items.length) {
                          return const Padding(
                            padding: EdgeInsets.all(30),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final place = items[index];
                        return CommonListItem(
                          title: place.name,
                          description: place.description,
                          trailing: Icon(
                            Icons.location_city_outlined,
                            size: 30,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onTap: () => context.pushNamed(
                            AppRouter.mapRouteName,
                            extra: [place.toMapMarkerEntity],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
          orElse: () => Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
