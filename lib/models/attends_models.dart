// lib/models/attendance_record_model.dart

import 'package:intl/intl.dart';

class AttendanceRecord {
  final String id;
  final DateTime scanTime;

  AttendanceRecord({required this.id, required this.scanTime});

  // Getter buat format tanggal dan waktu jadi lebih cakep
  String get formattedScanDateTime {
    // Format: 23 Juni 2025 - 08:26 WIB
    // 'id_ID' untuk format bahasa Indonesia
    final DateFormat formatter = DateFormat('dd MMMM yyyy - HH:mm', 'id_ID');
    // Menambahkan .toLocal() untuk menyesuaikan dengan zona waktu perangkat
    return '${formatter.format(scanTime.toLocal())} WIB';
  }

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    final String apiTimeString = json['scan_time'] ?? '';

    // Hapus 'Z' untuk mengabaikan info UTC dan memaksa Flutter membacanya sebagai waktu lokal
    final String naiveTimeString = apiTimeString.replaceAll('Z', '');

    // Sekarang parse string yang sudah "naif" (tanpa info zona waktu)
    final DateTime parsedTime =
        DateTime.tryParse(naiveTimeString) ?? DateTime.now();

    return AttendanceRecord(
      id: json['id'] ?? '',
      scanTime: parsedTime, // Gunakan waktu yang sudah di-parse secara naif
    );
  }
}
