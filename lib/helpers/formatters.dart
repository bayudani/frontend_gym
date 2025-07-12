import 'package:intl/intl.dart';

String formatTanggal(String? tanggalString) {
  if (tanggalString == null || tanggalString.isEmpty) {
    return 'Tidak ada tanggal';
  }

  try {
    DateTime tanggal = DateTime.parse(tanggalString);
    return DateFormat('d MMMM yyyy', 'id_ID').format(tanggal);
  } catch (e) {
    print('Error parsing tanggal: $e');
    return 'Format tanggal salah';
  }
}
