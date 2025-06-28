// lib/models/membership_plan_model.dart

import 'package:intl/intl.dart';

class MembershipPlan {
  final String id;
  final String name;
  final int durationInDays; // Kita anggap 'duration_months' itu sebenarnya hari
  final String price;

  MembershipPlan({
    required this.id,
    required this.name,
    required this.durationInDays,
    required this.price,
  });

  /// Getter Bantuan untuk format harga jadi "Rp 250.000"
  String get formattedPrice {
    final number = int.tryParse(price) ?? 0;
    // Pastikan package 'intl' sudah ada di pubspec.yaml
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(number);
  }

  /// Getter Bantuan untuk format durasi jadi "berlaku 90 hari"
  String get formattedDuration {
    // Logika untuk mengubah nama dari API menjadi lebih user-friendly
    if (name.toLowerCase().contains('satu bulan')) {
      return 'berlaku 30 hari';
    } else if (name.toLowerCase().contains('tiga bulan')) {
      return 'berlaku 90 hari';
    } else if (name.toLowerCase().contains('enam bulan')) {
      return 'berlaku 180 hari';
    } else if (name.toLowerCase().contains('satu tahun')) {
      return 'berlaku 365 hari';
    }
    // Fallback jika tidak ada yang cocok
    return 'berlaku $durationInDays hari';
  }

  factory MembershipPlan.fromJson(Map<String, dynamic> json) {
    return MembershipPlan(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Paket Membership',
      // API 'duration_months' sepertinya berisi hari, jadi kita simpan sebagai hari
      durationInDays: json['duration_months'] ?? 30,
      price: json['price']?.toString() ?? '0',
    );
  }
}