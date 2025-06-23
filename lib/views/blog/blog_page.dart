// lib/views/blog/blog_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/controllers/article_controller.dart'; // <-- IMPORT CONTROLLER
import 'package:gym_app/models/article_models.dart';      // <-- IMPORT MODEL
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  int _selectedIndex = 1; // Index 1 untuk Blog

  void _onItemTapped(int index) {
    // Navigasi akan di-handle oleh CustomBottomNavBar
    // Biarkan kosong jika navigasi sudah di-handle di dalam nav bar
    setState(() {
      _selectedIndex = index;
    });
  }

  // --- PERUBAHAN DI SINI ---
  // Widget untuk Kartu Artikel, sekarang menerima URL gambar
  Widget _buildArticleCard({
    required BuildContext context,
    required String title,
    required String date,
    required String imageUrl, // <-- Diubah dari imagePath ke imageUrl
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      height: 180,
      decoration: BoxDecoration(
        image: DecorationImage(
          // --- Menggunakan NetworkImage untuk memuat gambar dari URL ---
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.darken,
          ),
          // Tambahkan errorBuilder untuk antisipasi jika gambar gagal dimuat
          onError: (exception, stackTrace) {
             // Bisa diganti dengan gambar placeholder dari assets
            print('Error loading image: $exception');
          },
        ),
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[800], // Warna background sementara gambar loading
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end, // Judul di bawah
          children: [
            // Kontainer untuk tanggal dipindah ke atas judul agar lebih rapi
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
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
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Artikel Blog',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      // --- PEROMBAKAN BESAR DI BODY ---
      body: Consumer<ArticleController>(
        builder: (context, controller, child) {
          // 1. Tampilan saat LOADING
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          // 2. Tampilan saat ada ERROR
          if (controller.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Oops! Gagal memuat artikel: ${controller.errorMessage}',
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          
          // 3. Tampilan saat artikel KOSONG
          if (controller.articles.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada artikel yang tersedia.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          // 4. Tampilan saat data BERHASIL dimuat
          return ListView.builder(
            // --- Menggunakan controller.articles untuk mendapatkan SEMUA artikel ---
            itemCount: controller.articles.length,
            itemBuilder: (context, index) {
              final Article article = controller.articles[index];
              return _buildArticleCard(
                context: context,
                title: article.title,
                // --- Gunakan getter dari model yang sudah ada ---
                date: article.formattedPublishedDate,
                imageUrl: article.fullCoverPhotoUrl,
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}