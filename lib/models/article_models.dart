import 'package:intl/intl.dart';
import 'package:gym_app/config/app_config.dart';

class Article {

  final String id;
  final String title;
  final String coverPhotoPath;
  final DateTime publishedAt;
  

  final String slug; 
  final String? subTitle; 
  final String? body;
  final String? status;
  final String? photoAltText;
  final String? userId;

  Article({
  required this.id,
    required this.title,
    required this.slug,
    required this.coverPhotoPath,
    required this.publishedAt,
    this.subTitle,
    this.body,
    this.status,
    this.photoAltText,
    this.userId,
  });

  String get fullCoverPhotoUrl {
    final authority = Uri.parse(AppConfig.BaseUrl).authority;
    
    final unencodedPath = '/laravel/storage/$coverPhotoPath';

    return Uri.https(authority, unencodedPath).toString();
  }

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


  factory Article.fromJsonDetail(Map<String, dynamic> json) {
    return Article(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'No Title',
      slug: json['slug'] ?? '',
      coverPhotoPath: json['cover_photo_path'] ?? '',
      publishedAt: DateTime.tryParse(json['published_at'] ?? '') ?? DateTime.now(),
      subTitle: json['sub_title'],
      body: json['body'],
      status: json['status'],
      photoAltText: json['photo_alt_text'],
      userId: json['user_id']?.toString(),
    );
  }
}