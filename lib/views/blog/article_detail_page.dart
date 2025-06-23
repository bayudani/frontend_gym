import 'package:flutter/material.dart';
// Import widget-widget bagian yang baru
// ArticleReactions tidak lagi digunakan, jadi impornya bisa dihapus
// import 'package:gym_app/views/blog/article_reactions.dart';
import 'package:gym_app/views/blog/article_comments_section.dart'; // Tetap diimpor

class ArticleDetailPage extends StatefulWidget {
  final String title;
  final String date;
  final String imagePath; // Ini akan menerima URL gambar sekarang
  final String content; // Isi artikel
  final List<Map<String, String>> comments; // Contoh data komentar

  const ArticleDetailPage({
    super.key,
    required this.title,
    required this.date,
    required this.imagePath,
    required this.content,
    required this.comments,
  });

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  // State untuk melacak apakah artikel disukai atau tidak
  bool _isLiked = false;
  // State untuk melacak jumlah like saat ini
  late int _currentLikesCount; // Menggunakan late untuk inisialisasi di initState

  @override
  void initState() {
    super.initState();
    _currentLikesCount = 200; // Inisialisasi dari hardcoded value, atau dari widget.likesCount jika ada
    // Jika Anda ingin status like persist (misal dari API), Anda bisa inisialisasi _isLiked di sini
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _currentLikesCount++; // Tambah like
      } else {
        _currentLikesCount--; // Kurangi like
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background hitam
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
          'Kembali', // Mengubah teks AppBar menjadi "Kembali" seperti di gambar
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Gambar Artikel Utama
            Container(
              height: 250, // Tinggi gambar artikel
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imagePath), // Menggunakan NetworkImage
                  fit: BoxFit.cover,
                  // errorBuilder untuk DecorationImage perlu dibungkus dalam widget lain jika tidak bisa diterapkan langsung
                ),
              ),
              child: Stack(
                children: [
                  // Gambar utama dengan errorBuilder
                  Image.network(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    height: 250, // Pastikan ukuran sama dengan Container induk
                    width: double.infinity, // Pastikan lebar sama dengan Container induk
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading network image (errorBuilder): $error');
                      return Container(
                        height: 250, // Tinggi placeholder
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                        ),
                      );
                    },
                  ),
                  // Overlay gelap pada gambar
                  Container(
                    height: 250, // Sama dengan tinggi gambar
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(0.6), // Lebih gelap di bagian bawah
                        ],
                      ),
                    ),
                  ),
                  // PERBAIKAN: Like dan Komentar disatukan dalam satu Row
                  Positioned(
                    bottom: 10,
                    left: 20,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: _toggleLike, // Memanggil fungsi _toggleLike
                          child: Icon(
                            Icons.favorite,
                            color: _isLiked ? Colors.red : Colors.white, // Warna kondisional
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '$_currentLikesCount', // Menggunakan _currentLikesCount
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(width: 15), // Jarak antara like dan komentar
                        const Icon(Icons.comment, color: Colors.grey, size: 18), // Ikon komentar
                        const SizedBox(width: 5),
                        Text(
                          '${widget.comments.length}', // Jumlah komentar
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Judul Artikel dan Tanggal di bawah gambar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Ukuran font judul lebih besar
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.date,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14, // Ukuran font tanggal sedikit lebih besar
                    ),
                  ),
                ],
              ),
            ),
            // Isi Artikel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                widget.content,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.5, // Spasi baris
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Bagian Komentar - dipanggil sebagai ArticleCommentsSection
            ArticleCommentsSection(comments: widget.comments),
            const SizedBox(height: 20), // Padding bawah
          ],
        ),
      ),
    );
  }
}
