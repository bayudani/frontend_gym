import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/models/user_models.dart';
import 'package:gym_app/service/auth_service.dart';
import 'package:gym_app/service/token_service.dart';
import 'package:gym_app/views/auth/login_page.dart';
import 'package:gym_app/views/auth/verify_email_page.dart';
import 'package:gym_app/views/home/home_page.dart';

class AuthController with ChangeNotifier {
  final AuthService _authService = AuthService();
  final TokenService _tokenService = TokenService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    if (!context.mounted) return;
    _setLoading(true);

    try {
      await _authService.register(name, email, password);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi berhasil! Silakan cek email.'),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerifyEmailPage(email: email)),
      );
    } on DioException catch (e) {
      if (!context.mounted) return;
      _showError(context, e);
    } finally {
      _setLoading(false);
    }
  }

  Future<User?> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    if (!context.mounted) return null;
    _setLoading(true);

    try {
      final response = await _authService.login(email, password);

      final data = response.data;
      final token = data['token'];
      final user = User.fromJson(data['user']);

      if (token == null) {
        if (!context.mounted) return null;
        _showError(
          context,
          DioException(
            requestOptions: response.requestOptions,
            message: 'Token tidak ditemukan di response',
          ),
        );
        return null;
      }

      // Panggil TokenService untuk urusan simpan-menyimpan token
      await _tokenService.saveToken(token);

      if (!context.mounted) return null;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login berhasil!')));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
      return user;
    } on DioException catch (e) {
      if (!context.mounted) return null;
      _showError(context, e);
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyEmail({
    required String email,
    required String code,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.verifyEmail(email, code);
      final message = response.data['message'];
      _showSuccessSnackBar(context, message);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (route) => false,
      );
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Terjadi kesalahan.";
      _showErrorSnackBar(context, errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> logout(BuildContext context) async {
    await _tokenService.removeToken();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (route) => false,
    );
  }

  void _showError(BuildContext context, DioException e) {
    if (!context.mounted) return;

    String errorMessage = "Terjadi kesalahan tidak dikenal.";

    if (e.response != null && e.response?.data is Map) {
      final responseData = e.response!.data;
      errorMessage =
          responseData['message'] ??
          responseData['error'] ??
          "Gagal memproses permintaan.";
    } else {
      errorMessage = e.message ?? "Gagal terhubung ke server.";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
    );
  }
}
