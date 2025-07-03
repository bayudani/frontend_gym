// lib/views/program/program_detail_page.dart

import 'package:flutter/material.dart';
// import 'package:gym_app/models/program_models.dart'; // Tidak perlu diimpor jika tidak menerima objek Program

class ProgramDetailPage extends StatelessWidget {
  final String title;       // <<< Menerima title
  final String imageUrl;    // <<< Menerima imageUrl
  final String description; // <<< Menerima description

  const ProgramDetailPage({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Latar belakang gelap yang konsisten
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: 250.0, // Sesuaikan sesuai kebutuhan
            pinned: true, // AppBar tetap di bagian atas saat digulir
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 16.0, left: 60.0), // Sesuaikan posisi judul
              title: Text(
                title, // <<< Gunakan parameter title
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn, // Membuat gradien memudar dari atas ke bawah
                child: Image( // Menggunakan Image widget untuk fleksibilitas
                  image: imageUrl.isNotEmpty // Cek apakah URL/path gambar tidak kosong
                      ? NetworkImage(imageUrl) as ImageProvider // Asumsikan ini URL, jika tidak, ganti AssetImage
                      : const AssetImage('assets/images/default_program_image.jpg'), // Gambar default jika kosong
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/default_program_image.jpg', // Gambar default jika gagal
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, // <<< Gunakan parameter title
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description, // <<< Gunakan parameter description
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.5, // Spasi baris
                    ),
                    textAlign: TextAlign.justify,
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