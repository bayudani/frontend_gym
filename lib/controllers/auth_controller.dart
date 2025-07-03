// lib/controllers/auth_controller.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/models/user_models.dart';
import 'package:gym_app/service/auth_service.dart'; // <-- Ganti import
import 'package:gym_app/service/token_service.dart'; // <-- Tambah import
import 'package:gym_app/views/auth/login_page.dart';
import 'package:gym_app/views/auth/verify_email_page.dart';
import 'package:gym_app/views/home/home_page.dart';

// Jadikan ChangeNotifier untuk state management (misal: loading)
class AuthController with ChangeNotifier {
  // Ganti ApiService dengan service yang lebih spesifik
  final AuthService _authService = AuthService();
  final TokenService _tokenService = TokenService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Helper untuk mengubah state loading dan memberitahu UI
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
      // Panggil service yang benar
      await _authService.register(name, email, password);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil! Silakan cek email.')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyEmailPage(email: email),
        ),
      );
    } on DioException catch (e) {
      // Tangani error dari Dio dengan lebih modern
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

      // PENTING: Dio sudah otomatis decode JSON, hasilnya ada di `response.data`
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
        (route) => false, // Hapus semua halaman sebelumnya
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

  // --- FUNGSI BARU UNTUK VERIFIKASI KODE ---
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

      // Jika verifikasi berhasil, hapus semua halaman sebelumnya dan
      // arahkan ke halaman Login.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ), // Ganti ke SignInPage jika perlu
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

  // --- Helper untuk SnackBar (biar rapi) ---
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
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ), // Arahkan ke halaman login
      (route) => false,
    );
  }

  // Helper _showError sekarang menerima DioException agar lebih kuat
  void _showError(BuildContext context, DioException e) {
    if (!context.mounted) return;

    String errorMessage = "Terjadi kesalahan tidak dikenal.";

    // Cek apakah error berasal dari response server (misal: 4xx, 5xx)
    if (e.response != null && e.response?.data is Map) {
      final responseData = e.response!.data;
      errorMessage =
          responseData['message'] ??
          responseData['error'] ??
          "Gagal memproses permintaan.";
    } else {
      // Jika error karena koneksi, timeout, dll.
      errorMessage = e.message ?? "Gagal terhubung ke server.";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
    );
  }
}
