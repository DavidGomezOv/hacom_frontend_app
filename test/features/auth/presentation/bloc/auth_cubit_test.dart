import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hacom_frontend_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hacom_frontend_app/core/errors/server_failure.dart';
import 'package:hacom_frontend_app/features/auth/domain/auth_repository.dart';
import 'auth_cubit_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  AuthCubit getAuthCubit() => AuthCubit(authRepository: mockAuthRepository);

  group('AuthCubit initial', () {
    blocTest<AuthCubit, AuthState>(
      'initial state is AuthState.initial()',
      build: getAuthCubit,
      verify: (cubit) {
        expect(cubit.state, AuthState.initial());
        verifyZeroInteractions(mockAuthRepository);
      },
    );
  });

  group('AuthCubit login() Tests', () {
    const tAccountName = 'test_account';
    const tPhoneNumber = '123456789';

    blocTest<AuthCubit, AuthState>(
      'emits [loading, success] when login succeeds',
      setUp: () => when(
        mockAuthRepository.loginWithCredentials(
          accountName: anyNamed('accountName'),
          phoneNumber: anyNamed('phoneNumber'),
        ),
      ).thenAnswer((_) async => const Right(true)),
      build: getAuthCubit,
      act: (cubit) =>
          cubit.login(accountName: tAccountName, phoneNumber: tPhoneNumber),
      expect: () => [const AuthState.loading(), const AuthState.success()],
      verify: (cubit) {
        verify(
          mockAuthRepository.loginWithCredentials(
            accountName: tAccountName,
            phoneNumber: int.parse(tPhoneNumber),
          ),
        ).called(1);
        expect(cubit.state, const AuthState.success());
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [loading, failure(wrong credentials)] when login returns false',
      setUp: () => when(
        mockAuthRepository.loginWithCredentials(
          accountName: anyNamed('accountName'),
          phoneNumber: anyNamed('phoneNumber'),
        ),
      ).thenAnswer((_) async => const Right(false)),
      build: getAuthCubit,
      act: (cubit) =>
          cubit.login(accountName: tAccountName, phoneNumber: tPhoneNumber),
      expect: () => [
        const AuthState.loading(),
        const AuthState.failure(errorMessage: 'Wrong credentials'),
      ],
      verify: (cubit) {
        verify(
          mockAuthRepository.loginWithCredentials(
            accountName: tAccountName,
            phoneNumber: int.parse(tPhoneNumber),
          ),
        ).called(1);
        expect(
          cubit.state,
          const AuthState.failure(errorMessage: 'Wrong credentials'),
        );
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [loading, failure(generic error)] when login throws',
      setUp: () =>
          when(
            mockAuthRepository.loginWithCredentials(
              accountName: anyNamed('accountName'),
              phoneNumber: anyNamed('phoneNumber'),
            ),
          ).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: 'network error')),
          ),
      build: getAuthCubit,
      act: (cubit) =>
          cubit.login(accountName: tAccountName, phoneNumber: tPhoneNumber),
      expect: () => [
        const AuthState.loading(),
        const AuthState.failure(
          errorMessage: 'An error has occurred,  try again later',
        ),
      ],
      verify: (cubit) {
        verify(
          mockAuthRepository.loginWithCredentials(
            accountName: tAccountName,
            phoneNumber: int.parse(tPhoneNumber),
          ),
        ).called(1);
        expect(
          cubit.state,
          const AuthState.failure(
            errorMessage: 'An error has occurred,  try again later',
          ),
        );
      },
    );
  });

  group('AuthCubit checkLoginStatus() Tests', () {
    blocTest<AuthCubit, AuthState>(
      'emits [loading, success] when already logged in',
      setUp: () => when(
        mockAuthRepository.isAlreadyLoggedIn(),
      ).thenAnswer((_) async => const Right(true)),
      build: getAuthCubit,
      act: (cubit) => cubit.checkLoginStatus(),
      expect: () => [const AuthState.loading(), const AuthState.success()],
      verify: (cubit) {
        verify(mockAuthRepository.isAlreadyLoggedIn()).called(1);
        expect(cubit.state, const AuthState.success());
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [loading, initial] when not logged in',
      setUp: () => when(
        mockAuthRepository.isAlreadyLoggedIn(),
      ).thenAnswer((_) async => const Right(false)),
      build: getAuthCubit,
      act: (cubit) => cubit.checkLoginStatus(),
      expect: () => [const AuthState.loading(), const AuthState.initial()],
      verify: (cubit) {
        verify(mockAuthRepository.isAlreadyLoggedIn()).called(1);
        expect(cubit.state, const AuthState.initial());
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [loading, failure] when checkLoginStatus throws',
      setUp: () => when(mockAuthRepository.isAlreadyLoggedIn()).thenAnswer(
        (_) async => Left(ServerFailure(errorMessage: 'storage error')),
      ),
      build: getAuthCubit,
      act: (cubit) => cubit.checkLoginStatus(),
      expect: () => [
        const AuthState.loading(),
        const AuthState.failure(errorMessage: 'Error checking Login status'),
      ],
      verify: (cubit) {
        verify(mockAuthRepository.isAlreadyLoggedIn()).called(1);
        expect(
          cubit.state,
          const AuthState.failure(errorMessage: 'Error checking Login status'),
        );
      },
    );
  });

  group('AuthCubit logout() Tests', () {
    blocTest<AuthCubit, AuthState>(
      'emits [loading, logout] when logout succeeds',
      setUp: () => when(
        mockAuthRepository.logout(),
      ).thenAnswer((_) async => const Right(null)),
      build: getAuthCubit,
      act: (cubit) => cubit.logout(),
      expect: () => [const AuthState.loading(), const AuthState.logout()],
      verify: (cubit) {
        verify(mockAuthRepository.logout()).called(1);
        expect(cubit.state, const AuthState.logout());
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [loading, failure] when logout fails',
      setUp: () => when(mockAuthRepository.logout()).thenAnswer(
        (_) async => Left(ServerFailure(errorMessage: 'logout error')),
      ),
      build: getAuthCubit,
      act: (cubit) => cubit.logout(),
      expect: () => [
        const AuthState.loading(),
        const AuthState.failure(errorMessage: 'Logout error'),
      ],
      verify: (cubit) {
        verify(mockAuthRepository.logout()).called(1);
        expect(
          cubit.state,
          const AuthState.failure(errorMessage: 'Logout error'),
        );
      },
    );
  });
}
