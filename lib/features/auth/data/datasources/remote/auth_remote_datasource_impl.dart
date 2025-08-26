import 'dart:convert';

import 'package:hacom_frontend_app/core/network/api_client.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiClient apiClient;

  AuthRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<String?> login({required String accountName, required int phoneNumber}) async {
    try {
      final response = await apiClient.post("/login", {
        "phone": phoneNumber,
        "account": accountName,
      });

      if (response != null && response.statusCode == 200) {
        final data = (jsonDecode(response.body)) as Map<String, dynamic>;

        if (data.containsKey('token')) {
          apiClient.setToken(data["token"]);
          return data['token'];
        }
      }
      return null;
    } catch (e) {
      throw e.toString();
    }
  }
}
