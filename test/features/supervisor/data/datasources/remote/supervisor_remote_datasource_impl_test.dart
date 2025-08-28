import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hacom_frontend_app/core/network/api_client.dart';
import 'package:hacom_frontend_app/core/network/api_endpoints.dart';
import 'package:hacom_frontend_app/features/supervisor/data/datasources/remote/supervisor_remote_datasource_impl.dart';
import 'package:hacom_frontend_app/features/supervisor/domain/entities/vehicles_response_entity.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'supervisor_remote_datasource_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late SupervisorRemoteDatasourceImpl datasource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = SupervisorRemoteDatasourceImpl(apiClient: mockApiClient);
    clearInteractions(mockApiClient);
  });

  group('SupervisorRemoteDatasourceImpl getVehicles() Tests', () {
    const tPage = 1;
    const tLimit = 10;

    final tVehiclesJson = {
      "page": 1,
      "total": 200,
      "totalPages": 100,
      "data": [
        {
          "id": 1,
          "plate": "ABC123",
          "color": "FF0000",
          "label": "Vehículo liviano",
          "latitude": 8.035362,
          "longitude": -85.770799,
        },
        {
          "id": 2,
          "plate": "DEF456",
          "color": "00FF00",
          "label": "Camión de carga",
          "latitude": 10.187193,
          "longitude": -83.750903,
        },
      ],
    };

    final tVehiclesEntity = VehiclesResponseEntity.fromJson(tVehiclesJson);

    test('success api call returns VehiclesResponseEntity', () async {
      when(
        mockApiClient.get(
          '${ApiEndpoints.getPlaces}?page=$tPage&limit=$tLimit',
        ),
      ).thenAnswer((_) async => http.Response(jsonEncode(tVehiclesJson), 200));

      final result = await datasource.getVehicles(page: tPage, limit: tLimit);

      expect(result, isA<VehiclesResponseEntity>());
      expect(result.total, tVehiclesEntity.total);
      expect(result.vehicles.length, tVehiclesEntity.vehicles.length);
      verify(
        mockApiClient.get(
          '${ApiEndpoints.getPlaces}?page=$tPage&limit=$tLimit',
        ),
      ).called(1);
    });

    test('throws exception when response is null', () async {
      when(
        mockApiClient.get(
          '${ApiEndpoints.getPlaces}?page=$tPage&limit=$tLimit',
        ),
      ).thenAnswer((_) async => null);

      expect(
        () => datasource.getVehicles(page: tPage, limit: tLimit),
        throwsA(isA<String>()),
      );
      verify(
        mockApiClient.get(
          '${ApiEndpoints.getPlaces}?page=$tPage&limit=$tLimit',
        ),
      ).called(1);
    });

    test('throws exception when statusCode is not 200', () async {
      when(
        mockApiClient.get(
          '${ApiEndpoints.getPlaces}?page=$tPage&limit=$tLimit',
        ),
      ).thenAnswer((_) async => http.Response('Error', 401));

      expect(
        () => datasource.getVehicles(page: tPage, limit: tLimit),
        throwsA(isA<String>()),
      );
      verify(
        mockApiClient.get(
          '${ApiEndpoints.getPlaces}?page=$tPage&limit=$tLimit',
        ),
      ).called(1);
    });

    test('throws exception when ApiClient.get throws', () async {
      when(
        mockApiClient.get(
          '${ApiEndpoints.getPlaces}?page=$tPage&limit=$tLimit',
        ),
      ).thenThrow(Exception('Network error'));

      expect(
        () => datasource.getVehicles(page: tPage, limit: tLimit),
        throwsA(isA<String>()),
      );
      verify(
        mockApiClient.get(
          '${ApiEndpoints.getPlaces}?page=$tPage&limit=$tLimit',
        ),
      ).called(1);
    });
  });
}
