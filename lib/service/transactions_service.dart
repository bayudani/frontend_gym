
import 'package:dio/dio.dart';
import 'package:gym_app/service/dio_factory.dart';
import 'dart:io'; // Import untuk kelas File
import 'package:http_parser/http_parser.dart'; // Import untuk MediaType

class TransactionsService {
  final Dio _dio = DioFactory.create();


  // --- METHOD BARU UNTUK MEMBUAT TRANSAKSI ---
  Future<Response> createTransaction(Map<String, dynamic> textFields, File imageFile) async {
    // Dapatkan nama file dari path
    String fileName = imageFile.path.split('/').last;

    // Siapkan data form
    FormData formData = FormData.fromMap({
      ...textFields,
      // Backend controller Express mengharapkan field file dengan nama `proofFile` atau `proof_image`
      // sesuai konfigurasi multer. Kita coba 'proof_image' sesuai nama field di DB.
      "proof_image": await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        contentType: MediaType("image", "jpeg"), // atau "png", dll.
      ),
    });

    // Kirim request ke endpoint. Pastikan token otentikasi sudah di-handle oleh Dio Interceptor.
    return _dio.post('/transactions', data: formData);
  }
}
