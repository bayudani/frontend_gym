import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/models/chat_models.dart';
import 'package:gym_app/service/ai_service.dart';

class AiController extends ChangeNotifier {
  final AiService _aiService = AiService();

  // State untuk menyimpan daftar pesan
  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  // State untuk status loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Fungsi utama untuk mengirim pesan
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Tambahkan pesan user ke UI & set loading
    _messages.add(ChatMessage(text: text, isUserMessage: true));
    _isLoading = true;
    notifyListeners();

    try {
      // Panggil service untuk mengirim pesan ke backend
      final response = await _aiService.sendMessageToAI(text);

      if (response.statusCode == 200) {
        // Jika berhasil, ambil balasan AI dan tambahkan ke UI
        final aiReply = response.data['reply'];
        _messages.add(ChatMessage(text: aiReply, isUserMessage: false));
      } else {
        _handleError("Gagal mendapat balasan dari AI. Coba lagi.");
      }
    } on DioException catch (e) {
      // Tangani error dari Dio
      _handleError(e.response?.data['message'] ?? "Terjadi kesalahan koneksi.");
    } catch (e) {
      _handleError("Oops, terjadi kesalahan tidak terduga.");
    } finally {
      // Set loading kembali ke false
      _isLoading = false;
      notifyListeners();
    }
  }

  // fungsi untuk fect history
  Future<void> fetchHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _aiService.getChatHistory();
      if (response.statusCode == 200) {
        final List<dynamic> historyData = response.data;
        _messages =
            historyData.map((item) => ChatMessage.fromJson(item)).toList();

        if (_messages.isEmpty) {
          _messages.add(
            ChatMessage(
              text:
                  "Halo! Saya FitID AI, asisten virtualmu. Ada yang bisa dibantu seputar kebugaran?",
              isUserMessage: false,
            ),
          );
        }
      }
    } on DioException catch (e) {
      _handleError("Gagal memuat riwayat chat: ${e.response?.data['message']}");
    } catch (e) {
      _handleError("Oops, terjadi kesalahan tidak terduga.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Helper untuk menampilkan pesan error di chat
  void _handleError(String errorMessage) {
    _messages.add(
      ChatMessage(text: errorMessage, isUserMessage: false, isError: true),
    );
  }
}
