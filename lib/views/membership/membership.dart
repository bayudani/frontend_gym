import 'package:flutter/material.dart';
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';
import 'package:gym_app/views/home/home_page.dart'; // Import HomePage for navigation
// import 'package:gym_app/app_constants.dart'; // Import file konstanta jika ada untuk path gambar
// Jika Anda belum memiliki app_constants.dart, Anda bisa membuat file ini
// dan menempatkan path gambar di sana, atau definisikan langsung di sini.

// --- Placeholder for Images ---
const _membershipBannerImage = 'assets/images/membership_banner.png'; // Gambar banner membership
const _membershipGymBroImage = 'assets/images/membership_gym_bro.png'; // Gambar orang gym
const _barbellProgramImage = 'assets/images/barbell_program.png'; // Gambar untuk program
const _dumbbellProgramImage = 'assets/images/dumbbell_program.png'; // Gambar untuk program

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  int _selectedIndex = 2; // Assuming Membership is at index 1 in the new bottom nav order

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigation is handled by CustomBottomNavBar internally.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background utama hitam
      appBar: AppBar(
        backgroundColor: Colors.red, // AppBar merah
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        // Title dihilangkan karena gambar memiliki teks "Let's Join Membership" di bagian atas
        // title: const Text('Membership'),
      ),
      extendBodyBehindAppBar: true, // Untuk memperluas gambar di belakang AppBar
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent, // Transparan agar gambar terlihat
            expandedHeight: MediaQuery.of(context).size.height * 0.4, // Tinggi 40% dari layar
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    _membershipBannerImage, // Gambar latar belakang merah
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.red.withOpacity(0.0), // Awal transparan
                          Colors.red.withOpacity(0.5), // Akhir lebih merah
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 60, // Sesuaikan dengan tinggi status bar dan padding
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Let\'s Join',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Membership',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Dengan bergabung sebagai anggota\ndi gym anda telah memulai langkah\nawal untuk hidup yang lebih sehat',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Gambar orang gym di kanan bawah banner
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset(
                      _membershipGymBroImage, // Gambar orang gym
                      height: 200, // Tinggi gambar orang gym
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Section "40% discount" (reuse from HomePage)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFFE53935), // Red
                            Color(0xFF8B0000), // Darker Red
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  '📣 40% discount',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'on all our membership →',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image.asset(
                            _dumbbellProgramImage, // Reusing dumbbell icon from Home page, adjust if different
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Membership Options Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _buildMembershipOptionCard(
                        context,
                        title: 'Satu Bulan',
                        period: 'berlaku 30 hari',
                        price: 'RP 200.000',
                        imagePath: _barbellProgramImage, // Gambar untuk kartu membership
                      ),
                      const SizedBox(height: 20),
                      _buildMembershipOptionCard(
                        context,
                        title: 'Tiga Bulan',
                        period: 'berlaku 90 hari',
                        price: 'RP 585.000',
                        imagePath: _dumbbellProgramImage, // Gambar untuk kartu membership
                      ),
                      const SizedBox(height: 20),
                      _buildMembershipOptionCard(
                        context,
                        title: 'Enam Bulan',
                        period: 'berlaku 180 hari',
                        price: 'RP 1.100.000',
                        imagePath: _barbellProgramImage, // Gambar untuk kartu membership
                      ),
                      const SizedBox(height: 20),
                      _buildMembershipOptionCard(
                        context,
                        title: 'Satu Tahun',
                        period: 'berlaku 365 hari',
                        price: 'RP 2.000.000',
                        imagePath: _dumbbellProgramImage, // Gambar untuk kartu membership
                      ),
                      const SizedBox(height: 20),
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

  // Widget untuk kartu opsi membership
  Widget _buildMembershipOptionCard(
    BuildContext context, {
    required String title,
    required String period,
    required String price,
    required String imagePath,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 30, 30, 30), // Latar belakang abu-abu gelap
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                period,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                price,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  // Aksi ketika "Join membership" diklik
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Join $title diklik!')),
                  );
                },
                child: const Text(
                  'Join membership →',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Image.asset(
            imagePath, // Gambar di kanan kartu
            width: 80,
            height: 80,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
