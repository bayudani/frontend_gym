import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gym_app/models/attends_models.dart';
import 'package:gym_app/service/member_service.dart';

class AttendanceController extends ChangeNotifier {
  final MemberService _memberService = MemberService();

  List<AttendanceRecord> _records = [];
  List<AttendanceRecord> get records => _records;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAttendanceHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _memberService.getAttendanceHistory();
      // Ambil list 'attends' dari dalam respons API
      final List<dynamic> data = response.data['attends'];

      _records = data.map((json) => AttendanceRecord.fromJson(json)).toList();

      // Urutkan data dari yang paling baru (waktu scan terbesar)
      _records.sort((a, b) => b.scanTime.compareTo(a.scanTime));
    } on DioException catch (e) {
      _errorMessage =
          e.response?.data['message'] ?? 'Gagal memuat riwayat absen.';
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan tidak terduga.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
