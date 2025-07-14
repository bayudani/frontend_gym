import 'package:intl/intl.dart';
import 'package:gym_app/config/app_config.dart';

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

  String get fullImageUrl {
    if (image.isEmpty) return '';

    final authority = Uri.parse(AppConfig.BaseUrl).authority;

    final unencodedPath = '/laravel/storage/$image';

    return Uri.https(authority, unencodedPath).toString();
  }

  factory RewardItem.fromJson(Map<String, dynamic> json) {
    return RewardItem(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Reward Misterius',
      points: json['points'] ?? 0,
      image: json['image'] ?? '',
    );
  }
}
