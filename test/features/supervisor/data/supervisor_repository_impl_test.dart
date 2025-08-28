import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hacom_frontend_app/core/errors/server_failure.dart';
import 'package:hacom_frontend_app/features/supervisor/data/datasources/remote/supervisor_remote_datasource.dart';
import 'package:hacom_frontend_app/features/supervisor/data/supervisor_repository_impl.dart';
import 'package:hacom_frontend_app/features/supervisor/domain/entities/vehicles_response_entity.dart';

import 'supervisor_repository_impl_test.mocks.dart';

@GenerateMocks([SupervisorRemoteDatasource])
void main() {
  late SupervisorRepositoryImpl repository;
  late MockSupervisorRemoteDatasource mockRemoteDatasource;

  setUp(() {
    mockRemoteDatasource = MockSupervisorRemoteDatasource();
    repository = SupervisorRepositoryImpl(
      remoteDatasource: mockRemoteDatasource,
    );
    clearInteractions(mockRemoteDatasource);
  });

  group('SupervisorRepositoryImpl getVehicles() Tests', () {
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

    test(
      'returns Right(VehiclesResponseEntity) when datasource succeeds',
      () async {
        when(
          mockRemoteDatasource.getVehicles(page: tPage, limit: tLimit),
        ).thenAnswer((_) async => tVehiclesEntity);

        final result = await repository.getVehicles(page: tPage, limit: tLimit);

        expect(result, Right(tVehiclesEntity));
        verify(
          mockRemoteDatasource.getVehicles(page: tPage, limit: tLimit),
        ).called(1);
      },
    );

    test(
      'returns Left(ServerFailure) when datasource throws exception',
      () async {
        when(
          mockRemoteDatasource.getVehicles(page: tPage, limit: tLimit),
        ).thenThrow(Exception('Network error'));

        final result = await repository.getVehicles(page: tPage, limit: tLimit);

        expect(result.isLeft(), true);
        expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
        verify(
          mockRemoteDatasource.getVehicles(page: tPage, limit: tLimit),
        ).called(1);
      },
    );
  });
}
