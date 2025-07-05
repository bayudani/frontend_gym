// lib/models/reward_history_model.dart

import 'package:intl/intl.dart';
import 'package:gym_app/config/app_config.dart';

class RewardHistoryItem {
  final String name;
  final String? image;
  final DateTime? claimedAt;
  final String status;

  RewardHistoryItem({
    required this.name,
    this.image,
    this.claimedAt,
    required this.status,
  });

  // --- GETTER DIPERBAIKI MENIRU ATTENDANCE RECORD ---
  String get formattedDateTime {
    if (claimedAt == null) {
      return 'Tanggal tidak tersedia';
    }
    // 1. Format diubah menjadi: 23 Juli 2025 - 10:43
    final DateFormat formatter = DateFormat('dd MMMM yyyy - HH:mm', 'id_ID');
    // 2. Tambahkan .toLocal() untuk memastikan konversi zona waktu
    return '${formatter.format(claimedAt!.toLocal())} WIB';
  }
  
  String? get fullImageUrl {
    if (image == null || image!.isEmpty) {
      return null;
    }
    final baseUri = Uri.parse(AppConfig.BaseUrl);
    final unencodedPath = '/laravel/storage/$image';

    if (baseUri.isScheme('HTTPS')) {
      return Uri.https(baseUri.authority, unencodedPath).toString();
    } else {
      return Uri.http(baseUri.authority, unencodedPath).toString();
    }
  }

  // --- FACTORY DIPERBAIKI MENIRU ATTENDANCE RECORD ---
  factory RewardHistoryItem.fromJson(Map<String, dynamic> json) {
    DateTime? parsedTime;
    final String? apiTimeString = json['created_at']?.toString();

    if (apiTimeString != null) {
      // 1. Hapus 'Z' dari string waktu untuk mengabaikan info UTC
      final String naiveTimeString = apiTimeString.replaceAll('Z', '');
      // 2. Parse string waktu yang sudah "naif" (tanpa info zona waktu)
      parsedTime = DateTime.tryParse(naiveTimeString);
    }
    
    return RewardHistoryItem(
      name: json['item_reward']?['name']?.toString() ?? 'Nama Reward Tidak Ada',
      image: json['item_reward']?['image'],
      // 3. Gunakan waktu yang sudah diproses
      claimedAt: parsedTime,
      status: json['reward_status']?.toString() ?? 'Status Tidak Diketahui',
    );
  }
}