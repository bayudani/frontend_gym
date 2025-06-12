import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://81e4-110-137-110-236.ngrok-free.app/api';

  static Future<http.Response> register(
  String name,
  String email,
  String password,
) {
  return http.post(
    Uri.parse('$_baseUrl/auth/register'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "name": name,
      "email": email,
      "password": password,
    }),
  );
}


  static Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );
    return response;
  }
}
