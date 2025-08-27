abstract class AuthRemoteDatasource {
  Future<String?> login({required String accountName, required int phoneNumber});

  Future<void> setTokenFromLocalSource({required String? token});
}
