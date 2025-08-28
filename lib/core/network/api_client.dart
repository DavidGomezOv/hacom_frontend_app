import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  String? _token;

  ApiClient({required this.baseUrl});

  void setToken(String token) {
    _token = token;
  }

  Map<String, String> _headers() => {
    "Content-Type": "application/json",
    if (_token != null) "Authorization": "Bearer $_token",
  };

  Future<http.Response?> get(String endpoint) =>
      http.get(Uri.parse("$baseUrl$endpoint"), headers: _headers());

  Future<http.Response?> post(String endpoint, Map<String, dynamic> body) =>
      http.post(
        Uri.parse("$baseUrl$endpoint"),
        headers: _headers(),
        body: jsonEncode(body),
      );
}
