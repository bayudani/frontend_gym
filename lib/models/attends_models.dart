import 'package:intl/intl.dart';

class AttendanceRecord {
  final String id;
  final DateTime scanTime;

  AttendanceRecord({required this.id, required this.scanTime});

  // Getter buat format tanggal dan waktu
  String get formattedScanDateTime {
    final DateFormat formatter = DateFormat('dd MMMM yyyy - HH:mm', 'id_ID');
    return '${formatter.format(scanTime.toLocal())} WIB';
  }

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    final String apiTimeString = json['scan_time'] ?? '';

    final String naiveTimeString = apiTimeString.replaceAll('Z', '');

    final DateTime parsedTime =
        DateTime.tryParse(naiveTimeString) ?? DateTime.now();

    return AttendanceRecord(id: json['id'] ?? '', scanTime: parsedTime);
  }
}
