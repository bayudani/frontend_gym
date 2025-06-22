import 'package:flutter/material.dart';
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';
import 'package:gym_app/views/home/home_page.dart'; // Import HomePage for navigation
import 'package:gym_app/views/profile/profile_page.dart'; // Import ProfilePage for navigation
import 'package:gym_app/views/membership/membership_card_page.dart'; // Import MembershipCardPage for navigation

// --- Placeholder for Images ---
// Pastikan path gambar ini benar di pubspec.yaml dan folder assets Anda
const _membershipBannerImage = 'assets/images/Carousel.png'; // Menggunakan Carousel.png sebagai gambar latar belakang header
// const _membershipGymBroImage = 'assets/images/membership_gym_bro.png'; // Dihapus karena tidak lagi digunakan di header
const _barbellProgramImage = 'assets/images/barbell_program.png'; // Gambar untuk program
const _dumbbellProgramImage = 'assets/images/dumble.png'; // Gambar untuk program
const _megaphoneIconPath = 'assets/images/megaphone_icon.png'; // Icon megaphone untuk diskon
const _dumbbellIconPath = 'assets/images/dumble.png';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  int _selectedIndex = 2; // Assuming Membership is at index 1 in the bottom nav order (Home 0, Blog 1, Membership 2, Profile 3)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigasi ditangani oleh CustomBottomNavBar internally.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background utama hitam
      appBar: AppBar(
        backgroundColor: Colors.black, // AppBar hitam
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      // PERBAIKAN: extendBodyBehindAppBar diatur ke false agar latar belakang tidak di belakang AppBar
      // extendBodyBehindAppBar: true, 
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent, // Transparan agar gambar terlihat
            expandedHeight: MediaQuery.of(context).size.height * 0.25, // Tinggi 25% dari layar
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gambar latar belakang utama
                  Image.asset(
                    _membershipBannerImage,
                    fit: BoxFit.cover, // Memastikan gambar menutupi seluruh area
                  ),
                  // Gradien Overlay di atas gambar latar belakang
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2), // Sedikit transparan
                          Colors.black.withOpacity(0.5), // Lebih gelap di bawah
                        ],
                      ),
                    ),
                  ),
                  // Teks "Let's Join Membership"
                  Positioned(
                    // PERBAIKAN: Mengurangi nilai 'top' karena AppBar tidak lagi transparan di belakangnya
                    // Ini akan memposisikan teks relatif terhadap bagian atas FlexibleSpaceBar
                    top: 30, // Posisi teks dari atas FlexibleSpaceBar
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
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20.0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFFE53935), Color(0xFF8B0000)],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(_megaphoneIconPath, width: 35, height: 35),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                '40% discount',
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
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Image.asset(
                              _dumbbellIconPath,
                              width: 50,
                              height: 50,
                              fit: BoxFit.contain,
                            ),
                          ),
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
