// lib/service/auth_service.dart

import 'package:dio/dio.dart';
import 'package:gym_app/service/dio_factory.dart';

class AuthService {
  final Dio _dio = DioFactory.create();

  Future<Response> login(String email, String password) {
    return _dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> register(String name, String email, String password) {
    return _dio.post(
      '/auth/register',
      data: {'name': name, 'email': email, 'password': password},
    );
  }

  Future<Response> verifyEmail(String email, String code) {
    // Body request sesuai dengan yang diharapkan backend
    final data = {'email': email, 'code': code};
    return _dio.post('/auth/verify', data: data);
  }
}
