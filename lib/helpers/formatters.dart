// 
import 'package:intl/intl.dart';
// VERSI ANTI-CRASH
String formatTanggal(String? tanggalString) {
  // Cek jika string-nya null atau kosong
  if (tanggalString == null || tanggalString.isEmpty) {
    return 'Tidak ada tanggal'; // atau return '' (string kosong)
  }

  try {
    DateTime tanggal = DateTime.parse(tanggalString);
    return DateFormat('d MMMM yyyy', 'id_ID').format(tanggal);
  } catch (e) {
    // Jika terjadi error saat parsing (format tidak valid)
    print('Error parsing tanggal: $e');
    return 'Format tanggal salah'; // atau return tanggalString asli
  }
}