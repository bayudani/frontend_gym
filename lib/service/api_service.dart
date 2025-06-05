import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://192.168.1.7:8000/api';

  static Future<http.Response> register(
  String name,
  String email,
  String password,
  String passwordConfirmation,
) {
  return http.post(
    Uri.parse('$_baseUrl/register'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
    }),
  );
}


  static Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );
    return response;
  }
}
