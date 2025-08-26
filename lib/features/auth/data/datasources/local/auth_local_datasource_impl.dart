import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'auth_local_datasource.dart';

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final FlutterSecureStorage _secureStorage;
  static const _tokenKey = 'auth_token';

  AuthLocalDatasourceImpl({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  @override
  Future<void> saveToken(String token) async =>
      await _secureStorage.write(key: _tokenKey, value: token);

  @override
  Future<String?> getToken() async {
    final token = await _secureStorage.read(key: _tokenKey);
    if (token != null && !JwtDecoder.isExpired(token)) {
      return token;
    }
    await deleteToken();
    return null;
  }

  @override
  Future<void> deleteToken() async => await _secureStorage.delete(key: _tokenKey);

  @override
  Future<bool> hasValidToken() async {
    final token = await _secureStorage.read(key: _tokenKey);
    return token != null && !JwtDecoder.isExpired(token);
  }
}
