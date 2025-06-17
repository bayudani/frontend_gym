import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl =
      'https://65f7-103-156-248-97.ngrok-free.app/api';
  static const String _baseUrlLaravel =
      'https://e3f8-116-206-36-23.ngrok-free.app/api';

  final String baseUrl;

  ApiService({this.baseUrl = _baseUrl}); // default pakai baseUrl Express

  /// ==================== AUTH ====================

  static Future<http.Response> register(
    String name,
    String email,
    String password,
  ) {
    return http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );
  }

  static Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('Status login: ${response.statusCode}');
    print('Login response: ${response.body}');
    return response;
  }

  /// ==================== TOKEN ====================

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('Token saved: $token');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

 Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
  /// ==================== PROFILE ====================

  Future<Map<String, dynamic>?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print('Token not found');
      return null;
    }

    final url = Uri.parse(
      '$baseUrl/auth/profile',
    ); // Ganti sesuai base URL
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("❌ Gagal ambil profil: ${response.body}");
      return null;
    }
  }

  /// ==================== OPSIONAL: Update Profile ====================
  Future<bool> updateProfile(String name, String email) async {
    final token = await getToken();
    if (token == null) return false;

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/auth/update'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': name, 'email': email}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updateProfile: $e');
      return false;
    }
  }

  /// ==================== OPSIONAL: Ganti Password ====================
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    final token = await getToken();
    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/change-password'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error changePassword: $e');
      return false;
    }
  }
}
