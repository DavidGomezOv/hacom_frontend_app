import 'dart:convert';

import 'package:hacom_frontend_app/core/network/api_client.dart';
import 'package:hacom_frontend_app/core/network/api_endpoints.dart';
import 'package:hacom_frontend_app/features/places/data/datasources/remote/places_remote_datasource.dart';
import 'package:hacom_frontend_app/features/places/domain/entities/places_response_entity.dart';

class PlacesRemoteDatasourceImpl implements PlacesRemoteDatasource {
  final ApiClient apiClient;

  PlacesRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<PlacesResponseEntity> getPlaces({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.getPlaces}?page=$page&limit=$limit',
      );

      if (response == null || response.statusCode != 200) {
        throw Exception('Error fetching vehicles');
      }

      final Map<String, dynamic> data = jsonDecode(response.body);
      return PlacesResponseEntity.fromJson(data);
    } catch (e) {
      throw e.toString();
    }
  }
}
