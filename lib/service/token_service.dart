import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('token', token);
    print('Token saved: $token');
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('token');
  }

  Future<void> removeToken() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove('token');
    print('Token removed');
  }
}
