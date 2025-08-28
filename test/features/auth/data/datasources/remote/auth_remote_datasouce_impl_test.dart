import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hacom_frontend_app/core/network/api_client.dart';
import 'package:hacom_frontend_app/features/auth/data/datasources/remote/auth_remote_datasource_impl.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'auth_remote_datasouce_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late AuthRemoteDatasourceImpl authRemoteDatasourceImpl;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    authRemoteDatasourceImpl = AuthRemoteDatasourceImpl(apiClient: mockApiClient);
    clearInteractions(mockApiClient);
  });

  group('AuthDataSourceImpl login() Tests', () {
    const tToken = 'fake_token';
    const tAccountName = 'test_account';
    const tPhoneNumber = 123456789;
    const loginRequestParams = {"phone": tPhoneNumber, "account": tAccountName};

    test('success api call returns token', () async {
      final responseBody = jsonEncode({'token': tToken});

      when(
        mockApiClient.post("/login", loginRequestParams),
      ).thenAnswer((_) async => http.Response(responseBody, 200));

      final result = await authRemoteDatasourceImpl.login(
        accountName: tAccountName,
        phoneNumber: tPhoneNumber,
      );

      expect(result, tToken);
      verify(mockApiClient.setToken(tToken)).called(1);
    });

    test('success api call but no token in response returns null', () async {
      final responseBody = jsonEncode({'message': "Invalid credentials"});

      when(
        mockApiClient.post("/login", loginRequestParams),
      ).thenAnswer((_) async => http.Response(responseBody, 200));

      final result = await authRemoteDatasourceImpl.login(
        accountName: tAccountName,
        phoneNumber: tPhoneNumber,
      );

      expect(result, null);
      verifyNever(mockApiClient.setToken(tToken));
    });

    test('success api call returns null when response status is not 200', () async {
      final responseBody = jsonEncode({'token': tToken});

      when(
        mockApiClient.post("/login", loginRequestParams),
      ).thenAnswer((_) async => http.Response(responseBody, 401));

      final result = await authRemoteDatasourceImpl.login(
        accountName: tAccountName,
        phoneNumber: tPhoneNumber,
      );

      expect(result, null);
      verifyNever(mockApiClient.setToken(any));
    });

    test('failure api call throws exception when ApiClient throws', () async {
      when(mockApiClient.post("/login", loginRequestParams)).thenThrow(Exception('Network error'));

      expect(
        () => authRemoteDatasourceImpl.login(accountName: tAccountName, phoneNumber: tPhoneNumber),
        throwsA(isA<String>()),
      );

      verifyNever(mockApiClient.setToken(any));
    });
  });

  group('AuthDataSourceImpl setTokenFromLocalSource() Tests', () {
    const tToken = 'fake_token';

    test('setTokenFromLocalSource called once with valid token', () async {
      await authRemoteDatasourceImpl.setTokenFromLocalSource(token: tToken);

      verify(mockApiClient.setToken(tToken)).called(1);
    });

    test('setTokenFromLocalSource not called with invalid token', () async {
      await authRemoteDatasourceImpl.setTokenFromLocalSource(token: null);

      verifyNever(mockApiClient.setToken(tToken));
    });
  });
}
