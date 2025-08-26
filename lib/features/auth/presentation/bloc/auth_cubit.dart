import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hacom_frontend_app/features/auth/domain/auth_repository.dart';

part 'auth_state.dart';

part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(const AuthState.initial());

  Future<void> login({required String accountName, required int phoneNumber}) async {
    emit(AuthState.loading());

    final result = await authRepository.loginWithCredentials(
      accountName: accountName,
      phoneNumber: phoneNumber,
    );

    result.fold(
      (failure) => emit(AuthState.failure(errorMessage: 'An error has occurred,  try again later')),
      (authorized) {
        if (authorized) {
          emit(AuthState.success());
          return;
        }
        emit(AuthState.failure(errorMessage: 'Wrong credentials'));
      },
    );
  }

  Future<void> checkLoginStatus() async {
    emit(AuthState.loading());

    final result = await authRepository.isAlreadyLoggedIn();

    result.fold((failure) => emit(AuthState.failure(errorMessage: 'Error checking Login status')), (
      isLoggedIn,
    ) {
      if (isLoggedIn) {
        emit(AuthState.success());
      } else {
        emit(const AuthState.initial());
      }
    });
  }

  Future<void> logout() async {
    emit(AuthState.loading());

    final result = await authRepository.logout();

    result.fold(
      (failure) => emit(AuthState.failure(errorMessage: 'Logout error')),
      (_) => emit(const AuthState.initial()),
    );
  }
}
