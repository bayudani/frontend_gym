import 'package:flutter/material.dart';
import 'package:gym_app/models/membership_models.dart';
import 'package:gym_app/service/content_service.dart';

class MembershipController extends ChangeNotifier {
  final ContentService _contentService = ContentService();

  List<MembershipPlan> _plans = [];
  List<MembershipPlan> get plans => _plans;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  MembershipController() {
    fetchMemberships();
  }

  Future<void> fetchMemberships() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _contentService.getMemberships();
      final List<dynamic> data = response.data;
      _plans = data.map((json) => MembershipPlan.fromJson(json)).toList();
    } catch (e) {
      _errorMessage = 'Gagal memuat paket membership.';
      print('Error fetching memberships: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<MembershipPlan?> getMembershipById(String id) async {
    try {
      final response = await _contentService.getMembershipById(id);
      return MembershipPlan.fromJson(response.data);
    } catch (e) {
      print('Error fetching membership by ID: $e');
      return null;
    }
  }
}
