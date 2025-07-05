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

  Future<Response> getAttendanceHistory() async {
    try {
      // Panggil endpoint sesuai yang lo kasih
      final response = await _dio.get('/member/attends/me');
      return response;
    } catch (e) {
      // Biarkan DioException di-handle oleh controller
      rethrow;
    }
  }

  // claim reward
  Future<Response> claimReward(String rewardId) {
    return _dio.post('/member/rewards/$rewardId/claim');
  }

  Future<Response> getRewardHistory() {
    // Endpoint ini juga butuh otentikasi (token)
    return _dio.get('/member/rewards/history');
  }
}