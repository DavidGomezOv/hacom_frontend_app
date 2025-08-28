import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:hacom_frontend_app/features/auth/data/datasources/local/auth_local_datasource_impl.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockJwtDecoder extends Mock implements JwtDecoder {}

void main() {
  late AuthLocalDatasourceImpl authLocalDatasourceImpl;
  late MockFlutterSecureStorage mockFlutterSecureStorage;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    authLocalDatasourceImpl = AuthLocalDatasourceImpl(
      secureStorage: mockFlutterSecureStorage,
    );
  });

  const tToken = 'fake_jwt_token';
  const tokenKey = 'auth_token';

  test(
    'saveToken calls secureStorage.write with correct key and value',
    () async {
      when(
        () => mockFlutterSecureStorage.write(key: tokenKey, value: tToken),
      ).thenAnswer((_) async {});

      await authLocalDatasourceImpl.saveToken(tToken);

      verify(
        () => mockFlutterSecureStorage.write(key: tokenKey, value: tToken),
      ).called(1);
    },
  );

  test(
    'saveToken calls secureStorage.write with correct key and value',
    () async {
      when(
        () => mockFlutterSecureStorage.delete(key: tokenKey),
      ).thenAnswer((_) async {});

      await authLocalDatasourceImpl.deleteToken();

      verify(() => mockFlutterSecureStorage.delete(key: tokenKey)).called(1);
    },
  );
}
