// lib/widget/point/point_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:gym_app/controllers/profile_controller.dart';
import 'package:gym_app/controllers/item_rewards_controller.dart';
import 'package:gym_app/models/item_rewards_models.dart';
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';
import 'package:gym_app/widget/point/claim_reward_popup.dart';
import 'package:gym_app/widget/point/reward_history_page.dart'; // Import halaman riwayat reward

// --- Definisi Gambar dan Ikon ---
const String _pointIcon = 'assets/images/coin_stack.png';
const String _historyIcon = 'assets/images/history.png'; // Diubah namanya menjadi _historyIcon untuk konsistensi
const String _ribbonIcon = 'assets/images/ribbon.png';
const String _redGiftBoxImage = 'assets/images/red_gift_box.png';
const String _membershipBannerImage = 'assets/images/coooo.png';


class PointPage extends StatefulWidget {
  const PointPage({super.key});

  @override
  State<PointPage> createState() => _PointPageState();
}

class _PointPageState extends State<PointPage> {
  int _selectedIndex = 0; // Indeks item terpilih untuk bottom navigation bar

  @override
  void initState() {
    super.initState();
    // Memuat data setelah frame pertama selesai di-render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RewardController>(context, listen: false).fetchRewards();
      Provider.of<ProfileController>(context, listen: false).fetchProfile(context);
      Provider.of<ProfileController>(context, listen: false).fetchPoint(context);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Warna latar belakang halaman
      body: CustomScrollView(
        slivers: [
          _buildHeader(context), // Header halaman dengan informasi profil dan poin

          Consumer<RewardController>(
            builder: (context, controller, child) {
              // Tampilan Loading
              if (controller.isLoading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: Colors.white)),
                );
              }
              // Tampilan Error
              if (controller.errorMessage != null) {
                return SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        controller.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                );
              }
              // Tampilan jika tidak ada reward
              if (controller.rewards.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "Belum ada reward yang tersedia.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              }
              // Tampilan Grid Reward jika data tersedia
              return _buildRewardGrid(context, controller.rewards);
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // Widget untuk bagian header halaman
  Widget _buildHeader(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, profile, child) {
        final userName = profile.userProfile?.name ?? 'Guest'; // Nama pengguna atau 'Guest' jika null
        final userPoints = profile.userPoint?.point ?? 0; // Poin pengguna atau 0 jika null
        final formattedPoints = NumberFormat.decimalPattern('id_ID').format(userPoints); // Format poin

        return SliverAppBar(
          backgroundColor: Colors.black, // AppBar hitam
          expandedHeight: 250, // Tinggi AppBar saat diperluas
          // Leading (ikon kembali) secara otomatis diposisikan dengan baik oleh AppBar
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context), // Fungsi untuk kembali ke halaman sebelumnya
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF8B0000), Color(0xFFE53935)], // Gradien warna merah
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)), // Sudut melengkung di bagian bawah
              ),
              child: Stack(
                children: [
                  Positioned(
                    // === PERBAIKAN UTAMA DI SINI ===
                    // Menambahkan tinggi status bar + tinggi AppBar untuk memastikan teks tidak tumpang tindih
                    top: MediaQuery.of(context).padding.top + kToolbarHeight * 0.7, // kToolbarHeight adalah tinggi default AppBar
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Hello', style: TextStyle(color: Colors.white70, fontSize: 18)),
                        Text(
                          userName,
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    // Menyesuaikan posisi baris poin/history agar berada di bawah teks "Hello Bayu"
                    top: MediaQuery.of(context).padding.top + kToolbarHeight * 0.7 + 60, // Sesuaikan 60 ini jika terlalu dekat/jauh
                    left: 20,
                    child: Row(
                      children: [
                        // Container untuk menampilkan poin pengguna
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2), // Latar belakang transparan
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Image.asset(_pointIcon, width: 20, height: 20,), // Ikon poin
                              const SizedBox(width: 5),
                              Text('$formattedPoints Points', style: const TextStyle(color: Colors.white, fontSize: 14)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10), // Spasi antar container

                        // Container untuk tombol History dengan GestureDetector
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RewardHistoryPage(), // Navigasi ke RewardHistoryPage
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2), // Latar belakang transparan
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Image.asset(_historyIcon, width: 20, height: 20,), // Ikon history
                                const SizedBox(width: 5),
                                const Text('History', style: TextStyle(color: Colors.white, fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset(_redGiftBoxImage, height: 20, fit: BoxFit.contain), // Gambar kotak hadiah
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget untuk menampilkan grid reward
  Widget _buildRewardGrid(BuildContext context, List<RewardItem> rewards) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 kolom
          crossAxisSpacing: 16.0, // Spasi horizontal antar item
          mainAxisSpacing: 16.0, // Spasi vertikal antar item
          childAspectRatio: 0.7, // Rasio aspek item grid
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final reward = rewards[index];
            return _buildRewardCard(
              reward: reward,
              onClaim: () {
                showClaimSuccessPopup(context, reward.name); // Menampilkan popup klaim sukses
              },
            );
          },
          childCount: rewards.length, // Jumlah item di grid
        ),
      ),
    );
  }

  // Widget untuk menampilkan kartu reward individual
  Widget _buildRewardCard({
    required RewardItem reward,
    required VoidCallback onClaim,
  }) {
    final imageUrl = reward.fullImageUrl;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF262626), // Warna latar belakang kartu reward
        borderRadius: BorderRadius.circular(15), // Sudut membulat kartu
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                image: DecorationImage(
                  image: NetworkImage(imageUrl), // Gambar reward dari URL
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    // Penanganan error gambar bisa ditambahkan di sini
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    reward.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          reward.formattedPoints, // Poin yang dibutuhkan untuk reward
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: onClaim, // Fungsi saat tombol 'Klaim' ditekan
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Warna tombol
                          foregroundColor: Colors.white, // Warna teks tombol
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          minimumSize: Size.zero, // Membuat tombol sekompak mungkin
                        ),
                        child: const Text('Klaim', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}