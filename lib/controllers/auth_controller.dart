import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym_app/views/home/home_page.dart'; // Import halaman home_page Anda

import '../models/user_models.dart';
import '../service/api_service.dart';

class AuthController {
  Future<void> register({
    required String name,
    required String email,
    required String password,
    // required String passwordConfirmation,
    required BuildContext context,
  }) async {
    // Pastikan widget masih terpasang sebelum melanjutkan operasi UI
    if (!context.mounted) return;

    final res = await ApiService.register(name, email, password);

    // Pastikan widget masih terpasang sebelum menggunakan context lagi
    if (!context.mounted) return;

    if (res.statusCode == 201) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Register berhasil')));
      Navigator.pop(context); // Balik ke login
    } else {
      _showError(context, res.body);
    }
  }

  Future<User?> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    // Pastikan widget masih terpasang sebelum melanjutkan operasi UI
    if (!context.mounted) return null;

    final res = await ApiService.login(email, password);

    // Pastikan widget masih terpasang sebelum menggunakan context lagi
    if (!context.mounted) return null;

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      // Ambil token dan user
      final token = data['token'];
      final user = User.fromJson(data['user']);

      if (token == null) {
        _showError(context, 'Token tidak ditemukan di response');
        return null;
      }

      // Simpan token pakai ApiService
      await ApiService().saveToken(token);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login berhasil!')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      return user;
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  void _showError(BuildContext context, String message) {
    // Pastikan widget masih terpasang sebelum menggunakan context
    if (!context.mounted) return;

    String errorMessage;
    try {
      final decodedJson = jsonDecode(message);
      // Coba ambil pesan dari 'message' atau 'error', atau gunakan pesan default
      if (decodedJson is Map &&
          decodedJson.containsKey('message') &&
          decodedJson['message'] is String) {
        errorMessage = decodedJson['message'];
      } else if (decodedJson is Map &&
          decodedJson.containsKey('error') &&
          decodedJson['error'] is String) {
        errorMessage = decodedJson['error'];
      } else {
        errorMessage =
            'Terjadi kesalahan tidak dikenal.'; // Pesan default jika struktur JSON tidak sesuai
      }
    } catch (e) {
      errorMessage =
          'Terjadi kesalahan: ${e.toString()}'; // Tangani error jika bukan JSON valid
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(errorMessage)));
  }
}
