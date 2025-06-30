// lib/controllers/reward_controller.dart

import 'package:flutter/material.dart';
import 'package:gym_app/models/item_rewards_models.dart';
import 'package:gym_app/service/content_service.dart';
import 'package:dio/dio.dart';

class RewardController extends ChangeNotifier {
  final ContentService _contentService = ContentService();

  List<RewardItem> _rewards = [];
  List<RewardItem> get rewards => _rewards;

  bool _isLoading = true;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  RewardController() {
    fetchRewards();
  }

  Future<void> fetchRewards() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _contentService.getItemRewards();
      // Data reward ada di dalam key 'data'
      final List<dynamic> data = response.data['data'];
      _rewards = data.map((json) => RewardItem.fromJson(json)).toList();

    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? "Gagal memuat rewards. Coba lagi nanti.";
      print("Error fetching rewards: ${e.response?.data}");
    } catch (e) {
      _errorMessage = "Terjadi kesalahan tidak terduga.";
      print("Error fetching rewards: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
