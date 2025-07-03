// lib/models/reward_model.dart

import 'package:intl/intl.dart';
import 'package:gym_app/config/app_config.dart'; // <-- Pastikan ini di-import

class RewardItem {
  final String id;
  final String name;
  final int points;
  final String image;

  RewardItem({
    required this.id,
    required this.name,
    required this.points,
    required this.image,
  });

  String get formattedPoints {
    final format = NumberFormat.decimalPattern('id_ID');
    return '${format.format(points)} Poin';
  }

  // --- INI DIA PERBAIKANNYA, MENIRU MODEL ARTIKEL ---
  String get fullImageUrl {
    // Kalo path gambarnya kosong, jangan coba bangun URL
    if (image.isEmpty) return '';

    // 1. Ambil authority (domain/IP) dari BaseUrl
    final authority = Uri.parse(AppConfig.BaseUrl).authority;
    
    // 2. Tentukan path mentah ke storage Laravel-mu
    final unencodedPath = '/laravel/storage/$image';

    // 3. Gunakan Uri.https untuk membuat URL yang aman.
    // Ini cara yang sama persis dengan di model Article-mu.
    return Uri.https(authority, unencodedPath).toString();
  }
  // ---------------------------------------------------

  factory RewardItem.fromJson(Map<String, dynamic> json) {
    return RewardItem(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Reward Misterius',
      points: json['points'] ?? 0,
      image: json['image'] ?? '',
    );
  }
}
