import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/models/form_check_result_model.dart';
import 'package:gym_app/service/ai_service.dart';

class AiFormCheckerController extends ChangeNotifier {
  final AiService _aiService = AiService();

  // State
  bool _isLoading = false;
  FormCheckResult? _result;
  String? _errorMessage;

  // Getter
  bool get isLoading => _isLoading;
  FormCheckResult? get result => _result;
  String? get errorMessage => _errorMessage;

  /// Fungsi utama untuk memulai analisis gambar
  Future<void> analyzeForm({
    required File imageFile,
    required String exerciseName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _result = null;
    notifyListeners();

    try {
      final response = await _aiService.checkExerciseForm(
        imageFile: imageFile,
        exerciseName: exerciseName,
      );

      if (response.statusCode == 200) {
        _result = FormCheckResult.fromJson(response.data);
      } else {
        _errorMessage = "Gagal menganalisis gambar.";
      }
    } on DioException catch (e) {
      _errorMessage =
          e.response?.data['message'] ?? "Terjadi kesalahan koneksi.";
    } catch (e) {
      _errorMessage = "Terjadi kesalahan tidak terduga.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// untuk mereset state
  void clearResult() {
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }
}
