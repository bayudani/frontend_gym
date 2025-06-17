import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      'https://65f7-103-156-248-97.ngrok-free.app/api';
  // static const String _baseUrlLaravel =
  //     'https://e3f8-116-206-36-23.ngrok-free.app/api';

  // final String baseUrl;

  // ApiService({this.baseUrl = baseUrl}); // default pakai baseUrl Express

  /// ==================== AUTH ====================

  static Future<http.Response> register(
    String name,
    String email,
    String password,
  ) {
    return http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );
  }

  static Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
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
  /// ==================== MEMBER POINT ====================

  Future<Map<String, dynamic>?> getMemberPoint() async {
    final token = await getToken(); // Pakai method getToken() yang sudah ada

    if (token == null) {
      print('Token not found for getting points');
      return null;
    }

    // Pastikan base URL-nya bener ya. Gue asumsiin pake _baseUrl yang sama.
    final url = Uri.parse('$baseUrl/member/point'); 
    
    try {
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
        print("❌ Gagal ambil data poin: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Error saat manggil API poin: $e");
      return null;
    }
  }

  Future<List<dynamic>> getPrograms() async {
    // Asumsi endpoint ini tidak butuh token/otorisasi
    final url = Uri.parse('$baseUrl/programs/');
    
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // Lemparkan error agar bisa ditangkap di controller
        throw Exception('Gagal memuat daftar program: ${response.body}');
      }
    } catch (e) {
      print("❌ Error saat mengambil data program: $e");
      throw Exception('Gagal terhubung ke server program.');
    }
  }
  /// ==================== POSTS (ARTICLES) ====================
  Future<List<dynamic>> getPosts() async {
    final url = Uri.parse('$baseUrl/posts'); // Endpoint artikel dari Express

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal memuat artikel: ${response.body}');
      }
    } catch (e) {
      print("❌ Error saat mengambil data artikel: $e");
      throw Exception('Gagal terhubung ke server artikel.');
    }
  }

// member
  Future<Map<String, dynamic>?> getMemberData() async {
    final token = await getToken();
    if (token == null) {
      print('Token not found for getting member data');
      return null;
    }

    final url = Uri.parse('${ApiService.baseUrl}/member/profile');
    try {
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
        print("❌ Gagal ambil data member: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Error saat manggil API member: $e");
      return null;
    }
  }
}






