// lib/controllers/program_controller.dart

import 'package:flutter/material.dart';
import 'package:gym_app/models/program_models.dart';
import 'package:gym_app/service/api_service.dart'; // Sesuaikan path jika perlu

class ProgramController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Program> _programs = [];
  List<Program> get programs => _programs;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProgramController() {
    fetchPrograms(); // Langsung panggil saat controller dibuat
  }

  Future<void> fetchPrograms() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<dynamic> programData = await _apiService.getPrograms();
      _programs = programData.map((data) => Program.fromJson(data)).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}