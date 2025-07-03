import 'package:flutter/material.dart';
import 'package:gym_app/widget/custom_bottom_nav_bar.dart'; // Jika ingin Bottom Nav Bar di halaman ini
import 'package:gym_app/views/home/home_page.dart'; // Import untuk navigasi CustomBottomNavBar
import 'package:gym_app/views/profile/profile_page.dart'; // Import untuk navigasi CustomBottomNavBar
import 'package:gym_app/views/membership/membership.dart'; // Import untuk navigasi CustomBottomNavBar
import 'package:gym_app/views/blog/blog_page.dart'; // Import untuk navigasi CustomBottomNavBar


// --- Placeholder for Images ---
// Pastikan path gambar ini benar di pubspec.yaml dan folder assets Anda
const _isomaxProductImage = 'assets/images/isomax.png'; // Ganti dengan gambar produk Anda
const _wheyProteinProductImage = 'assets/images/whey_protein.png'; // Ganti dengan gambar produk Anda
const _ultimateNutritionImage = 'assets/images/ultimate_nutrition.png'; // Ganti dengan gambar produk Anda
const _lmenProductImage = 'assets/images/l_men.png'; // Ganti dengan gambar produk Anda

class RewardHistoryPage extends StatefulWidget {
  const RewardHistoryPage({super.key});

  @override
  State<RewardHistoryPage> createState() => _RewardHistoryPageState();
}

class _RewardHistoryPageState extends State<RewardHistoryPage> {
  // Untuk mengelola indeks item navigasi bawah (misalnya tetap di Home atau tidak ada)
  int _selectedIndex = 0; // Asumsi default ke Home jika tidak ada di BottomNavBar utama

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigasi ditangani oleh CustomBottomNavBar secara internal.
  }

  @override
  Widget build(BuildContext context) {
    // Contoh data riwayat hadiah. Dalam aplikasi nyata, ini akan diambil dari database/API.
    final List<Map<String, dynamic>> rewardRecords = [
      {
        'image': _isomaxProductImage,
        'name': 'ISOMAX',
        'date_time': '22 Juni 2025, 12.18',
        'status': 'Diklaim',
      },
      {
        'image': _wheyProteinProductImage,
        'name': 'WHEY PROTEIN',
        'date_time': '02 Januari 2025, 10.18',
        'status': 'Diklaim',
      },
      {
        'image': _ultimateNutritionImage,
        'name': 'ULTIMATE NUTRITION',
        'date_time': '28 Desember 2024, 11.18',
        'status': 'Diklaim',
      },
      {
        'image': _isomaxProductImage,
        'name': 'ISOMAX',
        'date_time': '12 Oktober 2024, 09.18',
        'status': 'Diklaim',
      },
      {
        'image': _lmenProductImage,
        'name': 'L MEN',
        'date_time': '10 Mei 2024, 20.18',
        'status': 'Diklaim',
      },
      {
        'image': _isomaxProductImage,
        'name': 'ISOMAX',
        'date_time': '09 Februari 2024, 15.18',
        'status': 'Diklaim',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black, // Latar belakang hitam
      appBar: AppBar(
        backgroundColor: Colors.black, // AppBar hitam
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: const Text(
          'Kembali', // Mengubah teks AppBar menjadi "Kembali"
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container( // Menggunakan Container untuk latar belakang di bawah AppBar
        color: const Color(0xFF262626), // Warna latar belakang sesuai gambar
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          itemCount: rewardRecords.length,
          itemBuilder: (context, index) {
            final record = rewardRecords[index];
            return _buildRewardHistoryCard(
              image: record['image'],
              name: record['name'],
              dateTime: record['date_time'],
              status: record['status'],
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // Widget untuk setiap kartu riwayat hadiah
  Widget _buildRewardHistoryCard({
    required String image,
    required String name,
    required String dateTime,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0), // Jarak antar kartu
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF333333), // Warna latar belakang kartu
        borderRadius: BorderRadius.circular(10), // Sudut membulat
        border: Border.all(color: Colors.grey[700]!), // Border abu-abu tipis
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan secara vertikal
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8), // Sudut gambar produk
            child: Image.asset(
              image,
              width: 60, // Lebar gambar produk
              height: 60, // Tinggi gambar produk
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  dateTime,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            status,
            style: const TextStyle(
              color: Colors.white70, // Warna teks status
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
