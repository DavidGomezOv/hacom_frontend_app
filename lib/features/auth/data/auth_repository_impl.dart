import 'package:dartz/dartz.dart';
import 'package:hacom_frontend_app/core/errors/server_failure.dart';
import 'package:hacom_frontend_app/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:hacom_frontend_app/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:hacom_frontend_app/features/auth/domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  final AuthLocalDatasource authLocalDatasource;

  AuthRepositoryImpl({required this.authRemoteDatasource, required this.authLocalDatasource});

  @override
  Future<Either<Failure, bool>> loginWithCredentials({
    required String accountName,
    required int phoneNumber,
  }) async {
    try {
      final token = await authRemoteDatasource.login(
        accountName: accountName,
        phoneNumber: phoneNumber,
      );

      if (token == null) {
        return Right(false);
      }

      await authLocalDatasource.saveToken(token);

      return Right(true);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isAlreadyLoggedIn() async {
    try {
      final result = await authLocalDatasource.hasValidToken();

      if (result) {
        final token = await authLocalDatasource.getToken();

        authRemoteDatasource.setTokenFromLocalSource(token: token);
      } else {
        await authLocalDatasource.deleteToken();
      }
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authLocalDatasource.deleteToken();

      return Right(null);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
