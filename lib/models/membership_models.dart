import 'package:intl/intl.dart';

class MembershipPlan {
  final String id;
  final String name;
  final int durationInDays;
  final String price;
  final String created_at;

  MembershipPlan({
    required this.id,
    required this.name,
    required this.durationInDays,
    required this.price,
    required this.created_at,
  });

  String get formattedPrice {
    final number = int.tryParse(price) ?? 0;
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return format.format(number);
  }

  String get formattedDuration {
    if (name.toLowerCase().contains('satu bulan')) {
      return 'berlaku 30 hari';
    } else if (name.toLowerCase().contains('tiga bulan')) {
      return 'berlaku 90 hari';
    } else if (name.toLowerCase().contains('enam bulan')) {
      return 'berlaku 180 hari';
    } else if (name.toLowerCase().contains('satu tahun')) {
      return 'berlaku 365 hari';
    }
    return 'berlaku $durationInDays bulan';
  }

  factory MembershipPlan.fromJson(Map<String, dynamic> json) {
    return MembershipPlan(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Paket Membership',
      durationInDays: json['duration_months'] ?? 30,
      price: json['price']?.toString() ?? '0',
      created_at: json['created_at'] ?? DateTime.now().toIso8601String(),
    );
  }
}
