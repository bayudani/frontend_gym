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
      final response = await _dio.get('/member/attends/me');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // claim reward
  Future<Response> claimReward(String rewardId) {
    return _dio.post('/member/rewards/$rewardId/claim');
  }

  Future<Response> getRewardHistory() {
    return _dio.get('/member/rewards/history');
  }

  Future<Response> finalizeReward(String claimId) {
    return _dio.put('/member/rewards/$claimId/finalize');
  }
}
