import 'package:dartz/dartz.dart';
import 'package:hacom_frontend_app/core/errors/server_failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> loginWithCredentials({
    required String accountName,
    required int phoneNumber,
  });

  Future<Either<Failure, bool>> isAlreadyLoggedIn();

  Future<Either<Failure, void>> logout();
}
