// lib/service/content_service.dart

import 'package:dio/dio.dart';
import 'package:gym_app/service/dio_factory.dart';

class ContentService {
  final Dio _dio = DioFactory.create();

  Future<Response> getPosts() {
    return _dio.get('/posts');
  }

  Future<Response> getPrograms() {
    return _dio.get('/programs');
  }
}