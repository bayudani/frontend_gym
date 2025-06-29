// lib/controllers/membership_checkout_controller.dart

import 'package:flutter/material.dart';
import 'package:gym_app/models/membership_models.dart';
import 'package:gym_app/service/content_service.dart';
import 'package:gym_app/service/transactions_service.dart';
import 'package:dio/dio.dart';
import 'dart:io'; // Import untuk kelas File

class MembershipCheckoutController extends ChangeNotifier {
  final ContentService _contentService = ContentService();
  final TransactionsService _transactionsService = TransactionsService();

  // --- State untuk Fetching Detail ---
  bool _isLoading = true;
  String? _errorMessage;
  MembershipPlan? _selectedPlan;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  MembershipPlan? get selectedPlan => _selectedPlan;

  // --- State Baru untuk Proses Submit Transaksi ---
  bool _isSubmitting = false;
  String? _submissionError;

  bool get isSubmitting => _isSubmitting;
  String? get submissionError => _submissionError;

  // --- Fungsi Fetching (sudah ada) ---
  Future<void> fetchMembershipDetails(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _contentService.getMembershipById(id);
      if (response.data != null) {
        _selectedPlan = MembershipPlan.fromJson(response.data);
      } else {
        throw Exception("API returned null data.");
      }
    } on DioException catch (e) {
      print('Dio error fetching membership details: ${e.response?.data}');
      _errorMessage = "Gagal terhubung ke server. Coba lagi nanti.";
    } catch (e) {
      print('Error fetching membership details: $e');
      _errorMessage = "Gagal memuat detail membership.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- FUNGSI BARU UNTUK SUBMIT TRANSAKSI ---
  /// Mengirim data transaksi ke API.
  /// Mengembalikan `true` jika sukses, `false` jika gagal.
  Future<bool> submitTransaction({
    required String fullName,
    required String address,
    required String phone,
    required File? proofImage,
  }) async {
    // 1. Validasi Input
    if (fullName.isEmpty || address.isEmpty || phone.isEmpty) {
      _submissionError = "Nama, alamat, dan No. HP wajib diisi.";
      notifyListeners();
      return false;
    }
    if (proofImage == null) {
      _submissionError = "Bukti transfer wajib di-upload.";
      notifyListeners();
      return false;
    }
    if (_selectedPlan == null) {
      _submissionError = "Paket membership tidak valid. Coba muat ulang halaman.";
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    _submissionError = null;
    notifyListeners();

    try {
      // 2. Siapkan data untuk dikirim
      final plan = _selectedPlan!;
      final formData = {
        'membership_package_id': plan.id,
        'amount': plan.price, // Kirim harga asli dari plan
        'full_name': fullName,
        'addres': address, // Sesuaikan dengan nama field di backend ('addres')
        'phone': phone,
      };

      // 3. Panggil service untuk membuat transaksi
      // Anggap `createTransaction` sudah ada di ContentService
      await _transactionsService.createTransaction(formData, proofImage);

      // 4. Jika berhasil
      _isSubmitting = false;
      notifyListeners();
      return true;

    } on DioException catch (e) {
      // Ambil pesan error dari response API jika ada
      _submissionError = e.response?.data['message'] ?? 'Gagal membuat transaksi. Terjadi masalah server.';
      print("Error creating transaction (Dio): ${e.response?.data}");
    } catch (e) {
      _submissionError = 'Gagal membuat transaksi. Coba lagi nanti.';
      print("Error creating transaction: $e");
    }

    // 5. Jika Gagal
    _isSubmitting = false;
    notifyListeners();
    return false;
  }
}
