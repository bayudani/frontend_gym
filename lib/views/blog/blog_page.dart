import 'package:flutter/material.dart';
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';
import 'package:gym_app/views/home/home_page.dart'; // Import HomePage for navigation
import 'package:gym_app/views/profile/profile_page.dart'; // Import ProfilePage for navigation
import 'package:gym_app/views/membership/membership_card_page.dart'; // Import MembershipCardPage for navigation
import 'package:gym_app/views/membership/membership.dart'; // Import MembershipPage for navigation
import 'package:gym_app/views/blog/article_detail_page.dart'; // Import ArticleDetailPage

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  // Untuk mengelola indeks item navigasi bawah yang dipilih
  // PERBAIKAN: Mengubah _selectedIndex menjadi 1 agar sesuai dengan indeks 'Blog' di CustomBottomNavBar
  int _selectedIndex = 1; // Index 1 karena ini halaman Blog

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigasi akan ditangani oleh CustomBottomNavBar secara internal.
  }

  // Widget untuk Kartu Artikel (reused from HomePage, slightly adapted for vertical list)
  Widget _buildArticleCard({
    required BuildContext context,
    required String title,
    required String date,
    required String imagePath,
    required String content, // Menambahkan content untuk ArticleDetailPage
    required List<Map<String, String>> comments, // Menambahkan comments untuk ArticleDetailPage
  }) {
    return GestureDetector( // PERBAIKAN: Membungkus kartu dengan GestureDetector
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailPage(
              title: title,
              date: date,
              imagePath: imagePath,
              content: content, // Meneruskan content
              comments: comments, // Meneruskan comments
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0), // Margin untuk setiap kartu
        height: 180, // Tinggi kartu artikel
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), // Overlay gelap pada gambar
              BlendMode.darken,
            ),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Contoh konten dan komentar untuk artikel
    final String defaultArticleContent = 'Ini adalah contoh isi artikel. Di dunia olahraga, terutama bagi mereka yang baru memulai rutinitas latihan beban, istilah \'arm-day\' dan \'leg-day\' kerap menjadi topik perbincangan yang menarik. Bagi pemula workout atau gymbro, menentukan fokus latihan hari ini seperti: apakah ingin memperkuat lengan atau kaki? sering kali menjadi dilema yang tidak berujung. Di balik latihan yang terdengar ringan ini, tersimpan pertimbangan penting yang membentuk pengalaman latihan seseorang, terutama dalam hal motivasi, konsistensi, dan hasil yang ingin dicapai.\n\nSolusi terbaik untuk mengatasi dilema ini adalah dengan menerapkan pendekatan latihan yang seimbang. Alih-alih terfokus hanya pada satu bagian tubuh, sebaiknya jadwal latihan dirancang agar melibatkan semua kelompok otot secara proporsional. Pendekatan menyeluruh ini tidak hanya mendukung perkembangan fisik yang lebih harmonis, tetapi juga mengurangi risiko cedera dan meningkatkan performa dalam jangka panjang. Tentu saja, setiap individu memiliki kondisi dan tujuan yang berbeda, sehingga penting untuk merancang program latihan yang sesuai dengan kebutuhan pribadi.';
    final List<Map<String, String>> defaultComments = const [
      {'user': 'ayam', 'time': '7 hari', 'comment': 'hebat banget'},
      {'user': 'hendriii01', 'time': '1 hari', 'comment': 'nyaman bgt gua ngegym disini bro....'},
      {'user': 'boni_jbe', 'time': '2 jam', 'comment': 'gasor kaleee'},
      {'user': 'king_bay', 'time': '1 jam', 'comment': 'sixpac rutar dulu doritos no satu!!'},
      {'user': 'klluutt_', 'time': '1 jam', 'comment': 'masih pemula kaa'},
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
          'Artikel Blog', // Judul halaman blog
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Daftar Artikel
            _buildArticleCard(
              context: context,
              title: 'Antara Arm Day dan Leg Day, Dilema Para Pemula Workout',
              date: '28 Mei 2025',
              imagePath: 'assets/images/arm_leg_day_article.png', // Gambar artikel
              content: defaultArticleContent,
              comments: defaultComments,
            ),
            _buildArticleCard(
              context: context,
              title: 'Lebih Dari Sekadar Otot, Inilah Dampak Latihan Angkat Beban Terhadap Tubuh Anda',
              date: '20 Mei 2025',
              imagePath: 'assets/images/muscle_impact_article.png', // Gambar artikel
              content: defaultArticleContent,
              comments: defaultComments,
            ),
            _buildArticleCard(
              context: context,
              title: 'Tips Memilih Suplemen Protein yang Tepat untuk Pembangunan Otot',
              date: '15 Mei 2025',
              imagePath: 'assets/images/protein_supplement_article.png', // Gambar artikel baru
              content: defaultArticleContent,
              comments: defaultComments,
            ),
            _buildArticleCard(
              context: context,
              title: 'Manfaat Kardio Selain Membakar Kalori: Meningkatkan Kesehatan Jantung dan Stamina',
              date: '10 Mei 2025',
              imagePath: 'assets/images/cardio_benefits_article.png', // Gambar artikel baru
              content: defaultArticleContent,
              comments: defaultComments,
            ),
            const SizedBox(height: 20), // Padding bawah
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
