import 'package:flutter/material.dart';
import 'package:gym_app/widget/custom_bottom_nav_bar.dart'; // Import CustomBottomNavBar
import 'package:gym_app/views/home/home_page.dart'; // Import HomePage for navigation
import 'package:gym_app/views/membership/membership.dart'; // Import MembershipPage for navigation
import 'package:gym_app/views/profile/profile_page.dart'; // Import ProfilePage for navigation
import 'package:gym_app/views/blog/blog_page.dart'; // Import BlogPage for navigation
import 'package:gym_app/widget/point/claim_reward_popup.dart'; // Import fungsi pop-up yang baru


// --- Placeholder for Images ---
// Pastikan path gambar ini benar di pubspec.yaml dan folder assets Anda
const _pointIcon = 'assets/images/coin_stack.png'; // Icon tumpukan koin/poin
const _ribbonIcon = 'assets/images/ribbon.png'; // Icon pita/reward
const _redGiftBoxImage = 'assets/images/red_gift_box.png'; // Gambar kotak kado merah

// Gambar produk reward (contoh)
const _isomaxProductImage = 'assets/images/isomax.png'; // Ganti dengan gambar produk Anda
const _wheyProteinProductImage = 'assets/images/whey_protein.png'; // Ganti dengan gambar produk Anda
const _ultimateNutritionImage = 'assets/images/ultimate_nutrition.png'; // Ganti dengan gambar produk Anda
const _lmenProductImage = 'assets/images/l_men.png'; // Ganti dengan gambar produk Anda


class PointPage extends StatefulWidget {
  const PointPage({super.key});

  @override
  State<PointPage> createState() => _PointPageState();
}

class _PointPageState extends State<PointPage> {
  // Indeks untuk BottomNavBar, asumsikan PointPage tidak ada di nav bar utama
  // jadi akan menyorot Home (0) secara default atau index yang sesuai jika ada di nav bar.
  int _selectedIndex = 0; 

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigasi ditangani oleh CustomBottomNavBar secara internal.
  }

  // Metode _showClaimSuccessPopup DIHAPUS dari sini, sekarang dipanggil dari claim_reward_popup.dart


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Contoh data rewards
    final List<Map<String, dynamic>> rewards = [
      {
        'image': _isomaxProductImage,
        'name': 'ISOMAX',
        'description': 'Suplemen gym pembentuk otot',
        'points': '10.000',
      },
      {
        'image': _wheyProteinProductImage,
        'name': 'WHEY PROTEIN',
        'description': 'Suplemen maksimalkan kebutuhan protein',
        'points': '20.000',
      },
      {
        'image': _ultimateNutritionImage,
        'name': 'ULTIMATE NUTRITION',
        'description': 'Memaksimalkan kekuatan otot dan mendukung pertumbuhan otot baru',
        'points': '30.000',
      },
      {
        'image': _lmenProductImage,
        'name': 'L MEN Platinum',
        'description': 'Suplemen nutrisi, meningkatkan performa latihan, dan pemulihan setelah latihan',
        'points': '40.000',
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
          '← Kembali', // Mengubah teks AppBar menjadi "Kembali"
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: CustomScrollView( // Menggunakan CustomScrollView untuk header yang melengkung
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 250, // Tinggi header
            floating: false,
            pinned: false, // Tidak pin AppBar saat scroll
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF8B0000), // Merah gelap
                      Color(0xFFE53935), // Merah cerah
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)), // Sudut membulat di bawah
                ),
                child: Stack(
                  children: [
                    // Teks "Hello Jhon"
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Hello',
                            style: TextStyle(color: Colors.white70, fontSize: 18),
                          ),
                          Text(
                            'Jhon',
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    // "10 Points" dan "Riwayat"
                    Positioned(
                      top: 100, // Menurunkan posisi vertikal
                      left: 20,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2), // Latar belakang transparan
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Image.asset(_pointIcon, width: 20, height: 20, color: Colors.white), // Icon poin
                                const SizedBox(width: 5),
                                const Text('10 Points', style: TextStyle(color: Colors.white, fontSize: 14)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Image.asset(_ribbonIcon, width: 20, height: 20, color: Colors.white), // Icon riwayat
                                const SizedBox(width: 5),
                                const Text('Riwayat', style: TextStyle(color: Colors.white, fontSize: 14)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Gambar kotak kado di kanan bawah
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset(_redGiftBoxImage, height: 120, fit: BoxFit.contain), // Gambar kotak kado
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Banner "Koleksi Point/Klaim Reward"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF262626), // Abu-abu gelap
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'koleksi point/klaim reward!',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Ayo gabung sebagai member sekarang juga!',
                                style: TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bagian "Klaim Reward"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Klaim Reward',
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              // Aksi untuk melihat semua reward
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('See all rewards diklik!')),
                              );
                            },
                            child: const Text('See all', style: TextStyle(color: Colors.red, fontSize: 16)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Daftar Reward dalam Grid
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(), // Non-scrollable GridView
                        shrinkWrap: true, // Ambil ruang sesuai konten
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 kolom
                          crossAxisSpacing: 16.0, // Spasi horizontal
                          mainAxisSpacing: 16.0, // Spasi vertikal
                          childAspectRatio: 0.7, // Rasio aspek item (tinggi / lebar)
                        ),
                        itemCount: rewards.length,
                        itemBuilder: (context, index) {
                          final reward = rewards[index];
                          return _buildRewardCard(
                            image: reward['image'],
                            name: reward['name'],
                            description: reward['description'],
                            points: reward['points'],
                            onClaim: () { // Menambahkan onTap untuk tombol Klaim
                              showClaimSuccessPopup(context, reward['name']); // Memanggil pop-up dari file terpisah
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20), // Padding bawah
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // Widget untuk kartu reward
  Widget _buildRewardCard({
    required String image,
    required String name,
    required String description,
    required String points,
    required VoidCallback onClaim, // Menambahkan callback untuk tombol Klaim
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF262626), // Latar belakang kartu reward
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              image,
              height: 120, // Tinggi gambar reward
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
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
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      points,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onClaim, // Memanggil callback onClaim
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size.zero, // Minimal size to fit content
                      ),
                      child: const Text('Klaim', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
