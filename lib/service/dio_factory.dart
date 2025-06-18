// lib/service/dio_factory.dart

import 'package:dio/dio.dart';
import 'package:gym_app/config/app_config.dart';
import 'package:gym_app/service/token_service.dart';

class DioFactory {
  static Dio create() {
    final tokenService = TokenService();
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // --- INTERCEPTOR OTOMATIS PENEMPEL TOKEN ---
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    // Interceptor untuk logging di console debug (sangat membantu)
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
    ));

    return dio;
  }
}