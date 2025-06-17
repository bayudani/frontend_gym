import 'package:flutter/material.dart';
// Removed unused import: import 'package:flutter_svg/flutter_svg.dart';
import 'package:gym_app/views/profile/profile_page.dart';
import 'package:gym_app/views/membership/membership_card_page.dart'; // Import MembershipCardPage
import 'package:gym_app/widget/custom_bottom_nav_bar.dart'; // Corrected Import CustomBottomNavBar path
import 'package:gym_app/views/blog/blog_page.dart'; // Import BlogPage
import 'package:gym_app/widget/point/point_page.dart'; // Import PointPage yang baru

// Import bagian-bagian baru
import 'package:gym_app/views/home/choose_program_section.dart';
import 'package:gym_app/views/home/article_section.dart';

// Assume you have a constants or utility file for SVG icons if you have more
// and want them centralized. For now, I'll include them here.
// const _profileIconPlaceholder = 'assets/images/1.png'; // Replace with your profile image path
const _dumbbellIconPath = 'assets/images/dumble.png'; // Path for the dumbbell icon in the banner
// PERBAIKAN: Mengatur path yang benar untuk ikon megaphone
const _megaphoneIconPath = 'assets/images/megaphone_icon.png'; // Path untuk ikon megaphone


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // To manage the index of the selected bottom navigation item

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigation is now handled by CustomBottomNavBar internally.
    // No direct navigation logic needed here.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Main black background
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black, // AppBar black
            expandedHeight: 200.0, // Expanded AppBar height
            floating: false,
            pinned: true, // Keep AppBar visible on scroll
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                // Background color behind FlexibleSpaceBar
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 30, 30, 30), // Darker shade for top
                      Colors.black,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 60.0, left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Hello',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'Jhon', // User name
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // Mengganti CircleAvatar menjadi GestureDetector untuk Poin
                          GestureDetector(
                            onTap: () {
                              // Navigasi ke halaman Poin saat diklik
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PointPage()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[800], // Latar belakang abu-abu gelap
                                borderRadius: BorderRadius.circular(20), // Sudut membulat
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min, // Sesuaikan ukuran kolom
                                children: const [
                                  Text(
                                    'Points', // Teks "Points"
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '1250', // Contoh jumlah poin
                                    style: TextStyle(
                                      color: Colors.yellow, // Warna poin (bisa disesuaikan)
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Let's start your day",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // PERBAIKAN: Discount / Promo Section - Disesuaikan dengan gambar kedua
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
                          // PERBAIKAN: Image.asset untuk ikon megaphone tanpa color property
                          Image.asset(
                            _megaphoneIconPath, // Ikon Megaphone
                            width: 35,
                            height: 35,
                            // Dihapus 'color: Colors.white' agar ikon menggunakan warna aslinya dari aset
                          ),
                          const SizedBox(width: 10), // Jarak antara ikon dan teks
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
                          // Container untuk gambar barbel dengan latar belakang putih
                          Container(
                            width: 65, // Sesuaikan lebar agar cocok dengan gambar
                            height: 65, // Sesuaikan tinggi agar cocok dengan gambar
                            decoration: BoxDecoration(
                              color: Colors.white, // Latar belakang putih
                              borderRadius: BorderRadius.circular(10), // Sedikit sudut membulat
                            ),
                            child: Center(
                              child: Image.asset(
                                _dumbbellIconPath, // Gambar barbel/dumbbell
                                width: 50, // Ukuran gambar barbel di dalam container
                                height: 50,
                                fit: BoxFit.contain, // Memastikan gambar pas di dalam container
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Memanggil widget ChooseProgramSection yang baru
                const ChooseProgramSection(),

                // Memanggil widget ArticleSection yang baru
                const ArticleSection(),
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

  // Widget for Program Card
  Widget _buildProgramCard(
      BuildContext context, String title, String subtitle, String duration, String imagePath) {
    return ClipRRect( // Tambahkan ClipRRect untuk border radius pada card
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45, // Program card width
        decoration: const BoxDecoration( // Gunakan const BoxDecoration
          color: Color.fromARGB(255, 30, 30, 30), // Card background color
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                imagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
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
                  const SizedBox(height: 4), // Mengurangi sedikit jarak
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70, // Warna putih keabuan untuk "Selengkapnya"
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8), // Jarak ke ikon jam
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.grey, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        duration,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Article Card
  Widget _buildArticleCard({
    required BuildContext context,
    required String title,
    required String date,
    required String imagePath,
  }) {
    return Container(
      height: 150, // Article card height
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5), // Dark overlay on image
            BlendMode.darken,
          ),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        // Tambahkan Padding untuk teks di dalam kartu
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Untuk menempatkan tanggal di paling atas
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6), // Latar belakang tanggal gelap transparan
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  date,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const Spacer(), // Mendorong judul ke bawah
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18, // Ukuran font judul disesuaikan
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2, // Batasi jumlah baris
              overflow: TextOverflow.ellipsis, // Tambahkan ellipsis jika teks terlalu panjang
            ),
          ],
        ),
      ),
    );
  }
}
