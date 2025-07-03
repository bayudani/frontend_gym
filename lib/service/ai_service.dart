import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gym_app/service/dio_factory.dart'; // Menggunakan DioFactory yang sudah ada
import 'package:http_parser/http_parser.dart'; // <-- 1. IMPORT PACKAGE BARU

class AiService {
  // Ambil instance Dio yang sudah dikonfigurasi dengan token, dll.
  final Dio _dio = DioFactory.create();

  /// Mengirim pesan ke backend Express untuk diteruskan ke Gemini
  Future<Response> sendMessageToAI(String message) {
    // Body request sesuai dengan yang diharapkan backend
    final data = {'message': message};

    // Panggil endpoint chat dengan metode POST
    return _dio.post('/ai/chat', data: data);
  }

// get history chat
  Future<Response> getChatHistory() {
    // Panggil endpoint chat history dengan metode GET
    return _dio.get('/ai/chat/history');
  }


  /// Mengirim gambar dan nama latihan untuk dianalisis (Form Checker)
  Future<Response> checkExerciseForm({
    required File imageFile,
    required String exerciseName,
  }) async {
    String fileName = imageFile.path.split('/').last;

    FormData formData = FormData.fromMap({
      "exerciseImage": await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        // --- 2. INI DIA PERBAIKANNYA: KASIH LABEL CONTENT-TYPE ---
        // Kita kasih tau secara eksplisit kalo ini adalah file gambar.
        contentType: MediaType('image', 'jpeg'), 
      ),
      "exerciseName": exerciseName,
    });

    return _dio.post(
      '/ai/check-form',
      data: formData,
      options: Options(
        headers: {
          // Dio akan otomatis set header 'multipart/form-data' saat menggunakan FormData
          // Jadi baris ini bisa kita hapus agar tidak duplikat
        },
      ),
    );
  }
}
