import 'package:intl/intl.dart';
import 'package:gym_app/service/api_service.dart'; // <-- Import ApiService

class Article {
  // Kita tidak perlu lagi URL base di sini, akan kita ambil dari ApiService

  final String id;
  final String title;
  final String coverPhotoPath; // Path relatif dari API Express
  final DateTime publishedAt;

  Article({
    required this.id,
    required this.title,
    required this.coverPhotoPath,
    required this.publishedAt,
  });

  // --- INI DIA PERBAIKANNYA ---
  String get fullCoverPhotoUrl {
    // 1. Ambil domain dari URL Ngrok (tanpa https://)
    final authority = Uri.parse(ApiService.baseUrl).authority;
    
    // 2. Tentukan path mentah (unencoded)
    final unencodedPath = '/laravel/storage/$coverPhotoPath';

    // 3. Gunakan Uri.https untuk membuat URL yang aman dan ter-encode otomatis
    // Dia akan mengubah spasi di `unencodedPath` menjadi %20
    return Uri.https(authority, unencodedPath).toString();
  }
  // ------------------------------

  String get formattedPublishedDate {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(publishedAt);
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? '',
      title: json['title'] ?? 'No Title',
      coverPhotoPath: json['cover_photo_path'] ?? '',
      publishedAt: DateTime.tryParse(json['published_at'] ?? '') ?? DateTime.now(),
    );
  }
}