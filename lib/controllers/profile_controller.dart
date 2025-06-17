import 'package:flutter/material.dart';
import 'package:gym_app/service/api_service.dart';
import 'package:gym_app/models/user_models.dart';
import 'package:gym_app/views/auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_app/models/member_models.dart'; // <-- IMPORT MODEL MEMBER

class ProfileController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _userProfile;
  bool _isLoading = true;
  String? _errorMessage;

  User? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

UserPoint? _userPoint; // <-- TAMBAH STATE UNTUK POIN
UserPoint? get userPoint => _userPoint; // <-- TAMBAH GETTER UNTUK POIN

// Bisa tambahin loading state terpisah biar lebih spesifik
  bool _isPointLoading = false;
  bool get isPointLoading => _isPointLoading;


Member? _memberData; // <-- TAMBAH STATE UNTUK MEMBER
  Member? get memberData => _memberData;

  bool _isMemberLoading = false; // <-- TAMBAH LOADING FLAG KHUSUS
  bool get isMemberLoading => _isMemberLoading;
  Future<void> fetchProfile(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();
      final profileData = await _apiService.getProfile();
      if (profileData != null) {
        _userProfile = User.fromJson(profileData);
        _errorMessage = null;
      } else {
        _errorMessage = 'Gagal mengambil data profil';
        _showSnackBar(context, _errorMessage!);
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      _showSnackBar(context, _errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveProfileChanges(
    BuildContext context,
    String name,
    String email,
  ) async {
    try {
      final success = await _apiService.updateProfile(name, email);
      if (success) {
        // Update data lokal
        _userProfile = _userProfile?.copyWith(name: name, email: email);
        _showSnackBar(context, '✅ Perubahan profil disimpan!');
      } else {
        _showSnackBar(context, '❌ Gagal menyimpan perubahan profil.');
      }
    } catch (e) {
      _showSnackBar(context, '❌ Terjadi error: $e');
    }
    notifyListeners();
  }

  Future<void> changePassword(
    BuildContext context,
    String oldPassword,
    String newPassword,
    String confirmNewPassword,
  ) async {
    if (newPassword != confirmNewPassword) {
      _showSnackBar(context, 'Konfirmasi password tidak cocok!');
      return;
    }
    try {
      // Simulate API call to change password
      // await _apiService.changePassword(oldPassword, newPassword);
      _showSnackBar(context, 'Password berhasil diubah!');
    } catch (e) {
      _showSnackBar(context, 'Gagal mengubah password: $e');
    }
    notifyListeners();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Hapus token atau session lainnya

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (Route<dynamic> route) => false,
    );

    _showSnackBar(context, '👋 Logout berhasil. Sampai jumpa lagi!');
  }

  // --- TAMBAHKAN FUNGSI BARU INI ---
  Future<void> fetchPoint(BuildContext context) async {
    _isPointLoading = true;
    notifyListeners();
    try {
      final pointData = await _apiService.getMemberPoint();
      if (pointData != null) {
        _userPoint = UserPoint.fromJson(pointData);
        _errorMessage = null;
      } else {
        _errorMessage = 'Gagal mengambil data poin';
      }
    } catch (e) {
      _errorMessage = 'Error fetching points: $e';
    } finally {
      _isPointLoading = false;
      notifyListeners();
    }
  }

  // --- TAMBAHKAN FUNGSI BARU INI ---
  Future<void> fetchMemberData() async {
    // Jika data sudah ada, tidak perlu fetch ulang
    if (_memberData != null) return;

    _isMemberLoading = true;
    notifyListeners();
    try {
      final data = await _apiService.getMemberData();
      if (data != null) {
        _memberData = Member.fromJson(data);
      }
    } catch (e) {
      _errorMessage = 'Error fetching member data: $e';
    } finally {
      _isMemberLoading = false;
      notifyListeners();
    }
  }
}
