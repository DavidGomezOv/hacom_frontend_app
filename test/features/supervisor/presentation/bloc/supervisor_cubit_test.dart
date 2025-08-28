import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hacom_frontend_app/features/supervisor/presentation/bloc/supervisor_cubit.dart';
import 'package:hacom_frontend_app/shared/cubit/paginated_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hacom_frontend_app/features/supervisor/domain/entities/vehicle_entity.dart';
import 'package:hacom_frontend_app/features/supervisor/domain/entities/vehicles_response_entity.dart';
import 'package:hacom_frontend_app/features/supervisor/domain/supervisor_repository.dart';
import 'supervisor_cubit_test.mocks.dart';

@GenerateMocks([SupervisorRepository])
void main() {
  late MockSupervisorRepository mockSupervisorRepository;

  setUp(() {
    mockSupervisorRepository = MockSupervisorRepository();
  });

  SupervisorCubit getSupervisorCubit() =>
      SupervisorCubit(repository: mockSupervisorRepository);

  group('SupervisorCubit initial', () {
    blocTest<SupervisorCubit, PaginatedState<VehicleEntity>>(
      'initial state is PaginatedState.initial()',
      build: getSupervisorCubit,
      verify: (cubit) {
        expect(cubit.state, PaginatedState<VehicleEntity>.initial());
        verifyZeroInteractions(mockSupervisorRepository);
      },
    );
  });

  group('SupervisorCubit fetch() Tests', () {
    final tVehicles = [
      VehicleEntity(id: 1, plate: 'plate', color: 'color'),
      VehicleEntity(id: 2, plate: 'plate', color: 'color'),
    ];
    final tResponse = VehiclesResponseEntity(
      total: 2,
      totalPages: 1,
      vehicles: tVehicles,
      page: 1,
    );

    blocTest<SupervisorCubit, PaginatedState<VehicleEntity>>(
      'emits [success] when fetch() succeeds',
      setUp: () => when(
        mockSupervisorRepository.getVehicles(page: 1, limit: 10),
      ).thenAnswer((_) async => Right(tResponse)),
      build: getSupervisorCubit,
      act: (cubit) => cubit.fetch(refresh: true),
      expect: () => [
        PaginatedState<VehicleEntity>.loading(),
        PaginatedState<VehicleEntity>.success(
          items: tVehicles,
          currentPage: 1,
          totalPages: 1,
          isFetching: false,
        ),
      ],
      verify: (cubit) {
        verify(
          mockSupervisorRepository.getVehicles(page: 1, limit: 10),
        ).called(1);
        final state = cubit.state;
        expect(
          state.whenOrNull(
            success: (items, currentPage, totalPages, isFetching) => items,
          ),
          tVehicles,
        );
      },
    );

    blocTest<SupervisorCubit, PaginatedState<VehicleEntity>>(
      'emits [failure] when fetch() fails',
      setUp: () => when(
        mockSupervisorRepository.getVehicles(page: 1, limit: 10),
      ).thenThrow(Exception('Network error')),
      build: getSupervisorCubit,
      act: (cubit) => cubit.fetch(refresh: true),
      expect: () => [
        PaginatedState<VehicleEntity>.loading(),
        PaginatedState<VehicleEntity>.failure(
          errorMessage: 'Exception: Network error',
        ),
      ],
      verify: (cubit) {
        verify(
          mockSupervisorRepository.getVehicles(page: 1, limit: 10),
        ).called(1);
        expect(
          cubit.state.whenOrNull(failure: (errorMessage) => errorMessage),
          'Exception: Network error',
        );
      },
    );

    blocTest<SupervisorCubit, PaginatedState<VehicleEntity>>(
      'accumulates items when fetching multiple pages',
      setUp: () {
        final tVehiclesPage = [
          VehicleEntity(id: 1, plate: 'plate', color: 'color'),
        ];
        final tResponsePage = VehiclesResponseEntity(
          total: 3,
          totalPages: 2,
          vehicles: tVehiclesPage,
          page: 1,
        );

        when(
          mockSupervisorRepository.getVehicles(page: 1, limit: 10),
        ).thenAnswer((_) async => Right(tResponse));
        when(
          mockSupervisorRepository.getVehicles(page: 2, limit: 10),
        ).thenAnswer((_) async => Right(tResponsePage));
      },

      build: getSupervisorCubit,
      act: (cubit) async {
        await cubit.fetch(refresh: true);
        await cubit.fetch(refresh: false);
      },
      expect: () => [
        PaginatedState<VehicleEntity>.loading(),
        PaginatedState<VehicleEntity>.success(
          items: tVehicles,
          currentPage: 1,
          totalPages: 1,
          isFetching: false,
        ),
        PaginatedState<VehicleEntity>.success(
          items: tVehicles,
          currentPage: 1,
          totalPages: 1,
          isFetching: true,
        ),
        PaginatedState<VehicleEntity>.success(
          items: [
            VehicleEntity(id: 1, plate: 'plate', color: 'color'),
            VehicleEntity(id: 2, plate: 'plate', color: 'color'),
            VehicleEntity(id: 1, plate: 'plate', color: 'color'),
          ],
          currentPage: 2,
          totalPages: 2,
          isFetching: false,
        ),
      ],
      verify: (cubit) {
        verify(
          mockSupervisorRepository.getVehicles(page: 1, limit: 10),
        ).called(1);
        verify(
          mockSupervisorRepository.getVehicles(page: 2, limit: 10),
        ).called(1);

        final state = cubit.state.whenOrNull(
          success: (items, currentPage, totalPages, isFetching) => items,
        );

        expect(state!.map((v) => v.id), [1, 2, 1]);
      },
    );
  });
}
