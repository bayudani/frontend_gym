
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/models/program_models.dart';
import 'package:gym_app/service/content_service.dart'; 

class ProgramController extends ChangeNotifier {
  // --- 2. Ganti dependency ke ContentService ---
  final ContentService _contentService = ContentService();

  List<Program> _programs = [];
  List<Program> get programs => _programs;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProgramController() {
    fetchPrograms();
  }

  // --- 3. Ubah method fetchPrograms ---
  Future<void> fetchPrograms() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _contentService.getPrograms();
      // Dio otomatis decode JSON, ambil datanya dari response.data
      final List<dynamic> programData = response.data;
      _programs = programData.map((data) => Program.fromJson(data)).toList();
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? e.message ?? "Failed to load programs.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}