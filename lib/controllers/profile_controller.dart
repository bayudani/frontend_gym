import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/models/member_models.dart';
import 'package:gym_app/models/user_models.dart';
import 'package:gym_app/service/member_service.dart';
import 'package:gym_app/service/token_service.dart';
import 'package:gym_app/service/user_service.dart';
import 'package:gym_app/views/auth/login_page.dart';

class ProfileController extends ChangeNotifier {
  final UserService _userService = UserService();
  final MemberService _memberService = MemberService();
  final TokenService _tokenService = TokenService();

  User? _userProfile;
  User? get userProfile => _userProfile;
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  UserPoint? _userPoint;
  UserPoint? get userPoint => _userPoint;
  bool _isPointLoading = false;
  bool get isPointLoading => _isPointLoading;

  Member? _memberData;
  Member? get memberData => _memberData;
  bool _isMemberLoading = false;
  bool get isMemberLoading => _isMemberLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isChangingPassword = false;
  bool get isChangingPassword => _isChangingPassword;

  bool get isMemberActive {
    return _memberData != null && _memberData!.isActive == true;
  }

  Future<void> fetchProfile(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _userService.getProfile();
      _userProfile = User.fromJson(response.data);
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
    if (newPassword != confirmNewPassword) {
      _showSnackBar(
        context,
        'Konfirmasi password baru tidak cocok!',
        isError: true,
      );
      return;
    }

    _isChangingPassword = true;
    notifyListeners();

    try {
      final response = await _userService.changePassword(
        currentPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmNewPassword,
      );

      _showSnackBar(
        context,
        response.data['message'] ?? 'Password berhasil diubah!',
      );
    } on DioException catch (e) {
      _handleError(e, context);
    } finally {
      _isChangingPassword = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    await _tokenService.removeToken();
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
    if (_memberData != null) return;

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

  void _handleError(DioException e, BuildContext context) {
    if (e.response != null && e.response?.data is Map) {
      final responseData = e.response!.data;
      _errorMessage =
          responseData['message'] ??
          responseData['error'] ??
          "Terjadi kesalahan pada server.";
    } else {
      _errorMessage = "Gagal terhubung ke server. Cek koneksi internetmu.";
    }
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
