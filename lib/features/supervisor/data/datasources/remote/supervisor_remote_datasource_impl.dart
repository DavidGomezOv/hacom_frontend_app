import 'dart:convert';

import 'package:hacom_frontend_app/core/network/api_client.dart';
import 'package:hacom_frontend_app/core/network/api_endpoints.dart';
import 'package:hacom_frontend_app/features/supervisor/data/datasources/remote/supervisor_remote_datasource.dart';
import 'package:hacom_frontend_app/features/supervisor/domain/entities/vehicles_response_entity.dart';

class SupervisorRemoteDatasourceImpl implements SupervisorRemoteDatasource {
  final ApiClient apiClient;

  SupervisorRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<VehiclesResponseEntity> getVehicles({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.getVehicles}?page=$page&limit=$limit',
      );

      if (response == null || response.statusCode != 200) {
        throw Exception('Error fetching vehicles');
      }

      final Map<String, dynamic> data = jsonDecode(response.body);
      return VehiclesResponseEntity.fromJson(data);
    } catch (e) {
      throw e.toString();
    }
  }
}
