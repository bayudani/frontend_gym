// lib/service/member_service.dart

import 'package:dio/dio.dart';
import 'package:gym_app/service/dio_factory.dart';

class MemberService {
  final Dio _dio = DioFactory.create();

  Future<Response> getMemberData() {
    return _dio.get('/member/profile');
  }

  Future<Response> getMemberPoint() {
    return _dio.get('/member/point');
  }
}