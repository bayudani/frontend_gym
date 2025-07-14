import 'package:dio/dio.dart';
import 'package:gym_app/service/dio_factory.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class TransactionsService {
  final Dio _dio = DioFactory.create();

  Future<Response> createTransaction(
    Map<String, dynamic> textFields,
    File imageFile,
  ) async {
    String fileName = imageFile.path.split('/').last;

    FormData formData = FormData.fromMap({
      ...textFields,

      "proof_image": await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        contentType: MediaType("image", "jpeg"),
      ),
    });

    return _dio.post('/transactions', data: formData);
  }
}
