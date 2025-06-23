import 'package:flutter/material.dart';
import 'package:gym_app/views/profile/attendance_history_page.dart'; // Import AttendanceHistoryPage

class AttendanceHistoryMenuItem extends StatelessWidget {
  const AttendanceHistoryMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.history, color: Colors.white), // Icon Riwayat Absen
      title: const Text('Riwayat Absen', style: TextStyle(color: Colors.white, fontSize: 18)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: () {
        // Karena ini dipanggil dari bottom sheet, kita perlu pop sheet-nya dulu
        if (Navigator.of(context).canPop()) { // Pastikan bisa di-pop
          Navigator.pop(context); // Tutup bottom sheet
        }
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const AttendanceHistoryPage()),
        );
      },
    );
  }
}
