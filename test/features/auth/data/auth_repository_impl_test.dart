import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hacom_frontend_app/core/errors/server_failure.dart';
import 'package:hacom_frontend_app/features/auth/data/auth_repository_impl.dart';
import 'package:hacom_frontend_app/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:hacom_frontend_app/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDatasource, AuthLocalDatasource])
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDatasource mockAuthRemoteDatasource;
  late MockAuthLocalDatasource mockAuthLocalDatasource;

  setUp(() {
    mockAuthRemoteDatasource = MockAuthRemoteDatasource();
    mockAuthLocalDatasource = MockAuthLocalDatasource();
    repository = AuthRepositoryImpl(
      authRemoteDatasource: mockAuthRemoteDatasource,
      authLocalDatasource: mockAuthLocalDatasource,
    );
  });

  const tAccountName = 'test_account';
  const tPhoneNumber = 123456789;
  const tToken = 'fake_token';

  group('AuthRepositoryImpl loginWithCredentials() Tests', () {
    test('returns Right(true) when login succeeds with token', () async {
      when(
        mockAuthRemoteDatasource.login(accountName: tAccountName, phoneNumber: tPhoneNumber),
      ).thenAnswer((_) async => tToken);
      when(mockAuthLocalDatasource.saveToken(tToken)).thenAnswer((_) async {});

      final result = await repository.loginWithCredentials(
        accountName: tAccountName,
        phoneNumber: tPhoneNumber,
      );

      expect(result, const Right(true));
      verify(mockAuthLocalDatasource.saveToken(tToken)).called(1);
    });

    test('returns Right(false) when login returns null', () async {
      when(
        mockAuthRemoteDatasource.login(accountName: tAccountName, phoneNumber: tPhoneNumber),
      ).thenAnswer((_) async => null);

      final result = await repository.loginWithCredentials(
        accountName: tAccountName,
        phoneNumber: tPhoneNumber,
      );

      expect(result, const Right(false));
      verifyNever(mockAuthLocalDatasource.saveToken(any));
    });

    test('returns Left(ServerFailure) when login throws exception', () async {
      when(
        mockAuthRemoteDatasource.login(accountName: tAccountName, phoneNumber: tPhoneNumber),
      ).thenThrow(Exception('network error'));

      final result = await repository.loginWithCredentials(
        accountName: tAccountName,
        phoneNumber: tPhoneNumber,
      );

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
    });
  });

  group('AuthRepositoryImpl isAlreadyLoggedIn() Tests', () {
    test('returns Right(true) and sets token if token is valid', () async {
      when(mockAuthLocalDatasource.hasValidToken()).thenAnswer((_) async => true);
      when(mockAuthLocalDatasource.getToken()).thenAnswer((_) async => tToken);
      when(
        mockAuthRemoteDatasource.setTokenFromLocalSource(token: tToken),
      ).thenAnswer((_) async {});

      final result = await repository.isAlreadyLoggedIn();

      expect(result, const Right(true));
      verify(mockAuthRemoteDatasource.setTokenFromLocalSource(token: tToken)).called(1);
    });

    test('returns Right(false) and deletes token if not valid', () async {
      when(mockAuthLocalDatasource.hasValidToken()).thenAnswer((_) async => false);
      when(mockAuthLocalDatasource.deleteToken()).thenAnswer((_) async {});

      final result = await repository.isAlreadyLoggedIn();

      expect(result, const Right(false));
      verify(mockAuthLocalDatasource.deleteToken()).called(1);
    });

    test('returns Left(ServerFailure) when datasource throws', () async {
      when(mockAuthLocalDatasource.hasValidToken()).thenThrow(Exception('storage error'));

      final result = await repository.isAlreadyLoggedIn();

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
    });
  });

  group('AuthRepositoryImpl logout() Tests', () {
    test('returns Right(null) when deleteToken succeeds', () async {
      when(mockAuthLocalDatasource.deleteToken()).thenAnswer((_) async {});

      final result = await repository.logout();

      expect(result, const Right(null));
      verify(mockAuthLocalDatasource.deleteToken()).called(1);
    });

    test('returns Left(ServerFailure) when deleteToken throws', () async {
      when(mockAuthLocalDatasource.deleteToken()).thenThrow(Exception('cannot delete'));

      final result = await repository.logout();

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
    });
  });
}
