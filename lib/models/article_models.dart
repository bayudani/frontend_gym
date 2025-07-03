import 'package:intl/intl.dart';
import 'package:gym_app/config/app_config.dart'; // <-- Import ApiService

class Article {
  // Kita tidak perlu lagi URL base di sini, akan kita ambil dari ApiService

  final String id;
  final String title;
  final String coverPhotoPath;
  final DateTime publishedAt;
  
  // --- TAMBAHAN: Field untuk halaman detail ---
  // Slug kita buat wajib ada karena penting buat navigasi & fetching
  final String slug; 
  // Field lain kita buat nullable (bisa kosong) karena hanya ada di response detail
  final String? subTitle; 
  final String? body;
  final String? status;
  final String? photoAltText;
  final String? userId;

  Article({
  required this.id,
    required this.title,
    required this.slug, // <-- Tambahkan di constructor
    required this.coverPhotoPath,
    required this.publishedAt,
    // Field opsional
    this.subTitle,
    this.body,
    this.status,
    this.photoAltText,
    this.userId,
  });

  // --- INI DIA PERBAIKANNYA ---
  String get fullCoverPhotoUrl {
    // 1. Ambil domain dari URL Ngrok (tanpa https://)
    final authority = Uri.parse(AppConfig.BaseUrl).authority;
    
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
      slug: json['slug'] ?? '',
      coverPhotoPath: json['cover_photo_path'] ?? '',
      publishedAt: DateTime.tryParse(json['published_at'] ?? '') ?? DateTime.now(),
    );
  }

  // --- FACTORY BARU UNTUK DETAIL ARTIKEL ---
  // Akan digunakan di ArticleDetailPage setelah fetch data by slug
  factory Article.fromJsonDetail(Map<String, dynamic> json) {
    return Article(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'No Title',
      slug: json['slug'] ?? '',
      coverPhotoPath: json['cover_photo_path'] ?? '',
      publishedAt: DateTime.tryParse(json['published_at'] ?? '') ?? DateTime.now(),
      // Mapping field detail
      subTitle: json['sub_title'],
      body: json['body'],
      status: json['status'],
      photoAltText: json['photo_alt_text'],
      userId: json['user_id']?.toString(),
    );
  }
}