import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // No longer needed directly in HomePage, unless used for other elements
import 'package:gym_app/views/profile/profile_page.dart';
import 'package:gym_app/views/membership/membership_card_page.dart'; // Import MembershipCardPage
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';

// Assume you have a constants or utility file for SVG icons if you have more
// and want them centralized. For now, I'll include them here.
const _profileIconPlaceholder = 'assets/images/profile_placeholder.png'; // Replace with your profile image path
const _dumbbellIconPath = 'assets/images/dumble.png'; // Path for the dumbbell icon in the banner

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
                          // Placeholder for profile image or avatar
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(_profileIconPlaceholder), // Replace with profile image
                            backgroundColor: Colors.grey[800],
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
                // Discount / Promo Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration( // Changed to const for BoxDecoration
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
                          // Placeholder for dumbbell image
                          Image.asset(
                            _dumbbellIconPath, // Replace with your dumbbell image
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover, // Ensure it fits correctly
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // "Choose Your Program" Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose Your Program',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 220, // Height for horizontal program list
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildProgramCard(
                              context,
                              'Full Body',
                              'Selengkapnya',
                              '2 - 3 times a week',
                              'assets/images/full_body_program.png', // Replace with program image
                            ),
                            const SizedBox(width: 15),
                            _buildProgramCard(
                              context,
                              'Upper and I', // Corrected from 'Upper and l'
                              'Selengkapnya',
                              '4 times',
                              'assets/images/upper_body_program.png', // Replace with program image
                            ),
                            const SizedBox(width: 15),
                            // Add more cards if needed
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // "Artikel" Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Artikel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Action to view all articles
                            },
                            child: const Text(
                              'See all',
                              style: TextStyle(
                                color: Colors.red, // Red color for "See all"
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _buildArticleCard(
                        context,
                        title: 'Antara Arm Day dan Leg Day, Dilema Para Pemula Workout',
                        date: '28 Mei 2025',
                        imagePath: 'assets/images/arm_leg_day_article.png', // Gambar artikel baru
                      ),
                      const SizedBox(height: 15),
                      _buildArticleCard(
                        context,
                        title: 'Lebih Dari Sekadar Otot, Inilah Dampak Latihan Angkat Beban Terhadap Tubuh Anda',
                        date: '20 Mei 2025',
                        imagePath: 'assets/images/muscle_impact_article.png', // Gambar artikel baru
                      ),
                      const SizedBox(height: 20), // Bottom padding before bottom nav
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Menggunakan CustomBottomNavBar di sini
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
  Widget _buildArticleCard(BuildContext context, {required String title, required String date, required String imagePath}) {
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
      child: Padding( // Tambahkan Padding untuk teks di dalam kartu
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Untuk menempatkan tanggal di paling atas
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
