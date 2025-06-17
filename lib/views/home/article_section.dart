import 'package:flutter/material.dart';
import 'package:gym_app/views/blog/blog_page.dart'; // Import BlogPage untuk navigasi

// Import gambar yang diperlukan
const _armLegDayArticleImage = 'assets/images/3.png';
const _muscleImpactArticleImage = 'assets/images/1.png';
const _proteinSupplementArticleImage = 'assets/images/3.png';
const _cardioBenefitsArticleImage = 'assets/images/1.png';


class ArticleSection extends StatelessWidget {
  const ArticleSection({super.key});

  // Widget untuk Kartu Artikel
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

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  // Navigasi ke BlogPage saat "See all" diklik
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BlogPage()),
                  );
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
            context: context,
            title: 'Antara Arm Day dan Leg Day, Dilema Para Pemula Workout',
            date: '28 Mei 2025',
            imagePath: _armLegDayArticleImage, // Gambar artikel
          ),
          const SizedBox(height: 15),
          _buildArticleCard(
            context: context,
            title: 'Lebih Dari Sekadar Otot, Inilah Dampak Latihan Angkat Beban Terhadap Tubuh Anda',
            date: '20 Mei 2025',
            imagePath: _muscleImpactArticleImage, // Gambar artikel
          ),
          const SizedBox(height: 20), // Padding bawah sebelum bottom nav
        ],
      ),
    );
  }
}
