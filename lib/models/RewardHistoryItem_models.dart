import 'package:intl/intl.dart';
import 'package:gym_app/config/app_config.dart';

class RewardHistoryItem {
  final String id;

  final String name;
  final String? image;
  final DateTime? claimedAt;
  final String status;

  RewardHistoryItem({
    required this.id,
    required this.name,
    this.image,
    this.claimedAt,
    required this.status,
  });

  String get formattedDateTime {
    if (claimedAt == null) {
      return 'Tanggal tidak tersedia';
    }
    final DateFormat formatter = DateFormat('dd MMMM yyyy - HH:mm', 'id_ID');
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

  factory RewardHistoryItem.fromJson(Map<String, dynamic> json) {
    DateTime? parsedTime;
    final String? apiTimeString = json['created_at']?.toString();

    if (apiTimeString != null) {
      final String naiveTimeString = apiTimeString.replaceAll('Z', '');
      parsedTime = DateTime.tryParse(naiveTimeString);
    }

    return RewardHistoryItem(
      id: json['id']?.toString() ?? 'ID Tidak Diketahui',
      name: json['item_reward']?['name']?.toString() ?? 'Nama Reward Tidak Ada',
      image: json['item_reward']?['image'],
      claimedAt: parsedTime,
      status: json['reward_status']?.toString() ?? 'Status Tidak Diketahui',
    );
  }
}
