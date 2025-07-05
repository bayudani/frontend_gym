// lib/controllers/reward_history_controller.dart

import 'package:flutter/material.dart';
import 'package:gym_app/models/RewardHistoryItem_models.dart';
import 'package:gym_app/service/member_service.dart';
import 'package:dio/dio.dart';

class RewardHistoryController extends ChangeNotifier {
  final MemberService _memberService = MemberService();

  List<RewardHistoryItem> _history = [];
  List<RewardHistoryItem> get history => _history;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _memberService.getRewardHistory();
      // TAMBAHKAN BARIS INI UNTUK DEBUGGING
      print("===== RESPONSE HISTORY DARI API =====");
      print(response.data);
      print("====================================");

      final List<dynamic> data = response.data['data'];
      _history = data.map((json) => RewardHistoryItem.fromJson(json)).toList();
    } on DioException catch (e) {
      _errorMessage = e.response?.data['error'] ?? 'Gagal memuat histori.';
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan tidak terduga.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}