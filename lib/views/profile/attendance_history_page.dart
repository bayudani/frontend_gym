import 'package:flutter/material.dart';
// Impor CustomBottomNavBar dan impor terkait dihapus karena tidak lagi digunakan di halaman ini
// import 'package:gym_app/widgets/custom_bottom_nav_bar.dart';
// import 'package:gym_app/views/home/home_page.dart';
// import 'package:gym_app/views/profile/profile_page.dart';
// import 'package:gym_app/views/membership/membership_page.dart';


class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({super.key});

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  // _selectedIndex dan _onItemTapped dihapus karena BottomNavigationBar tidak lagi digunakan.
  // int _selectedIndex = 2; 

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // Contoh data riwayat absen. Dalam aplikasi nyata, ini akan diambil dari database/API.
    final List<Map<String, dynamic>> attendanceRecords = [
      {'date': '10/06/2025', 'present': true},
      {'date': '11/06/2025', 'present': true},
      {'date': '12/06/2025', 'present': false},
      {'date': '13/06/2025', 'present': true},
      {'date': '14/06/2025', 'present': false},
      {'date': '15/06/2025', 'present': true},
    ];

    return Scaffold(
      backgroundColor: Colors.black, // Latar belakang hitam pekat untuk seluruh Scaffold
      appBar: AppBar(
        backgroundColor: Colors.black, // AppBar hitam pekat
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: const Text(
          'Riwayat Absen',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container( // Menggunakan Container untuk latar belakang di bawah AppBar
        color: Colors.black, // PERBAIKAN: Mengubah warna latar belakang body menjadi hitam pekat
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          itemCount: attendanceRecords.length,
          itemBuilder: (context, index) {
            final record = attendanceRecords[index];
            return _buildAttendanceCard(record['date'], record['present']);
          },
        ),
      ),
      // bottomNavigationBar dihapus dari sini
      // bottomNavigationBar: CustomBottomNavBar(
      //   selectedIndex: _selectedIndex,
      //   onItemTapped: _onItemTapped,
      // ),
    );
  }

  // Widget untuk setiap kartu riwayat absen
  Widget _buildAttendanceCard(String date, bool present) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0), // Jarak antar kartu
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: const Color(0xFF333333), // Warna latar belakang kartu (tetap abu-abu gelap)
        borderRadius: BorderRadius.circular(10), // Sudut membulat
        border: Border.all(color: Colors.grey[700]!), // Border abu-abu tipis
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(
            present ? Icons.check_circle : Icons.cancel, // Ikon centang atau silang
            color: present ? const Color(0xFF4CAF50) : const Color(0xFFF44336), // Warna ikon hijau atau merah yang lebih akurat
            size: 28,
          ),
        ],
      ),
    );
  }
}
