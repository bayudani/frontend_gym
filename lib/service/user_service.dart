import 'package:dio/dio.dart';
import 'package:gym_app/service/dio_factory.dart';

class UserService {
  final Dio _dio = DioFactory.create();

  Future<Response> getProfile() {
    return _dio.get('/auth/profile');
  }

  Future<Response> updateProfile(String name, String email) {
    return _dio.put('/auth/update', data: {'name': name, 'email': email});
  }

  Future<Response> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    return _dio.put(
      '/auth/update-password',
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );
  }
}
