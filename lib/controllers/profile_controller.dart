import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/models/member_models.dart';
import 'package:gym_app/models/user_models.dart';
import 'package:gym_app/service/member_service.dart'; // <-- IMPORT BARU
import 'package:gym_app/service/token_service.dart'; // <-- IMPORT BARU
import 'package:gym_app/service/user_service.dart'; // <-- IMPORT BARU
import 'package:gym_app/views/auth/login_page.dart'; // Sesuaikan path jika perlu

class ProfileController extends ChangeNotifier {
  // === 1. GANTI DEPENDENCY DARI ApiService KE SERVICE YANG LEBIH SPESIFIK ===
  final UserService _userService = UserService();
  final MemberService _memberService = MemberService();
  final TokenService _tokenService = TokenService();

  // --- State untuk Profil User ---
  User? _userProfile;
  User? get userProfile => _userProfile;
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // --- State untuk Poin Member ---
  UserPoint? _userPoint;
  UserPoint? get userPoint => _userPoint;
  bool _isPointLoading = false;
  bool get isPointLoading => _isPointLoading;

  // --- State untuk Data Kartu Member ---
  Member? _memberData;
  Member? get memberData => _memberData;
  bool _isMemberLoading = false;
  bool get isMemberLoading => _isMemberLoading;

  // --- State untuk pesan error ---
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // state password
  bool _isChangingPassword = false;
  bool get isChangingPassword => _isChangingPassword;

  // === 2. SEMUA FUNGSI SEKARANG PAKAI SERVICE YANG SESUAI & TRY-CATCH DIO ===

bool get isMemberActive {
    // User dianggap member aktif jika data member ada dan statusnya true
    return _memberData != null && _memberData!.isActive == true;
  }

  Future<void> fetchProfile(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _userService.getProfile();
      _userProfile = User.fromJson(
        response.data,
      ); // <-- Ambil dari response.data
      _errorMessage = null;
    } on DioException catch (e) {
      _handleError(e, context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveProfileChanges({
    required BuildContext context,
    required String name,
    required String email,
  }) async {
    try {
      await _userService.updateProfile(name, email);
      // Jika berhasil, update data lokal dan kasih notif
      _userProfile = _userProfile?.copyWith(name: name, email: email);
      _showSnackBar(context, '✅ Perubahan profil disimpan!');
      notifyListeners();
    } on DioException catch (e) {
      _handleError(e, context);
    }
  }

  Future<void> changePassword({
    required BuildContext context,
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    // 1. Validasi di sisi client terlebih dahulu
    if (newPassword != confirmNewPassword) {
      _showSnackBar(
        context,
        'Konfirmasi password baru tidak cocok!',
        isError: true,
      );
      return;
    }

    // 2. Set loading jadi true & kasih tau UI
    _isChangingPassword = true;
    notifyListeners();

    try {
      // 3. Panggil service untuk ganti password
      final response = await _userService.changePassword(
        currentPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmNewPassword,
      );

      // 4. Jika berhasil (tidak ada error), tampilkan pesan sukses dari server
      _showSnackBar(
        context,
        response.data['message'] ?? 'Password berhasil diubah!',
      );
    } on DioException catch (e) {
      // 5. Jika gagal, tampilkan error dari server
      _handleError(e, context);
    } finally {
      // 6. Apapun yang terjadi, set loading jadi false lagi
      _isChangingPassword = false;
      notifyListeners();
    }
  }

  // === 3. LOGOUT SEKARANG MEMANGGIL TokenService ===
  Future<void> logout(BuildContext context) async {
    await _tokenService.removeToken(); // <-- Lebih bersih!
    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (Route<dynamic> route) => false,
    );
    _showSnackBar(context, '👋 Logout berhasil. Sampai jumpa lagi!');
  }

  Future<void> fetchPoint(BuildContext context) async {
    _isPointLoading = true;
    notifyListeners();
    try {
      final response = await _memberService.getMemberPoint();
      _userPoint = UserPoint.fromJson(response.data);
      _errorMessage = null;
    } on DioException catch (e) {
      _handleError(e, context);
    } finally {
      _isPointLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMemberData(BuildContext context) async {
    if (_memberData != null)
      return; // Tidak perlu fetch ulang jika data sudah ada

    _isMemberLoading = true;
    notifyListeners();
    try {
      final response = await _memberService.getMemberData();
      _memberData = Member.fromJson(response.data);
      _errorMessage = null;
    } on DioException catch (e) {
      _handleError(e, context);
    } finally {
      _isMemberLoading = false;
      notifyListeners();
    }
  }

  // === 4. HELPER UNTUK MENANGANI ERROR DAN NOTIFIKASI ===

  void _handleError(DioException e, BuildContext context) {
    // Set pesan error dari response Dio
    if (e.response != null && e.response?.data is Map) {
      final responseData = e.response!.data;
      _errorMessage =
          responseData['message'] ??
          responseData['error'] ??
          "Terjadi kesalahan pada server.";
    } else {
      _errorMessage = "Gagal terhubung ke server. Cek koneksi internetmu.";
    }
    // Tampilkan pesan error di Snackbar
    _showSnackBar(context, _errorMessage!, isError: true);
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}
