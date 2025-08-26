abstract class AuthLocalDatasource {
  Future<void> saveToken(String token);

  Future<String?> getToken();

  Future<void> deleteToken();

  Future<bool> hasValidToken();
}
