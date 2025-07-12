import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gym_app/service/dio_factory.dart';
import 'package:http_parser/http_parser.dart';

class AiService {
  final Dio _dio = DioFactory.create();

  Future<Response> sendMessageToAI(String message) {
    final data = {'message': message};

    return _dio.post('/ai/chat', data: data);
  }

  // get history chat
  Future<Response> getChatHistory() {
    return _dio.get('/ai/chat/history');
  }

  Future<Response> checkExerciseForm({
    required File imageFile,
    required String exerciseName,
  }) async {
    String fileName = imageFile.path.split('/').last;

    FormData formData = FormData.fromMap({
      "exerciseImage": await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,

        contentType: MediaType('image', 'jpeg'),
      ),
      "exerciseName": exerciseName,
    });

    return _dio.post(
      '/ai/check-form',
      data: formData,
      options: Options(headers: {}),
    );
  }
}
