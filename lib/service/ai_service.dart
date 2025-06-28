import 'package:dio/dio.dart';
import 'package:gym_app/service/dio_factory.dart'; // Menggunakan DioFactory yang sudah ada

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
}
