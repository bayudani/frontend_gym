import 'package:flutter/material.dart';
import 'package:gym_app/models/item_rewards_models.dart';
import 'package:gym_app/service/content_service.dart';
import 'package:gym_app/service/member_service.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/controllers/profile_controller.dart';

class RewardController extends ChangeNotifier {
  final ContentService _contentService = ContentService();
  final MemberService _memberService = MemberService();

  List<RewardItem> _rewards = [];
  List<RewardItem> get rewards => _rewards;

  bool _isLoading = true;
  String? _errorMessage;

  bool _isClaiming = false;
  bool get isClaiming => _isClaiming;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;


  Future<void> fetchRewards() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _contentService.getItemRewards();
      final List<dynamic> data = response.data['data'];
      _rewards = data.map((json) => RewardItem.fromJson(json)).toList();
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? "Gagal memuat rewards. Coba lagi nanti.";
    } catch (e) {
      _errorMessage = "Terjadi kesalahan tidak terduga.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi klaim reward
  Future<String?> claimReward(BuildContext context, String rewardId) async {
    _isClaiming = true;
    notifyListeners();

    try {
      await _memberService.claimReward(rewardId);


      await fetchRewards();
      await Provider.of<ProfileController>(context, listen: false).fetchPoint(context);

      _isClaiming = false;
      notifyListeners();
      return null;

    } on DioException catch (e) {
      _isClaiming = false;
      notifyListeners();
      final error = e.response?.data['error'] ?? "Gagal klaim reward. Coba lagi.";
      return error;
    } catch (e) {
      _isClaiming = false;
      notifyListeners();
      return "Terjadi kesalahan yang tidak diketahui.";
    }
  }
}