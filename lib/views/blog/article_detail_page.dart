// lib/views/blog/article_detail_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:gym_app/controllers/article_controller.dart';
import 'package:gym_app/views/blog/article_comments_section.dart';

class ArticleDetailPage extends StatefulWidget {
  final String slug;

  const ArticleDetailPage({
    super.key,
    required this.slug,
  });

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {

  @override
  void initState() {
    super.initState();
    // Saat halaman ini dibuka, langsung minta controller untuk ambil data artikel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ArticleController>(context, listen: false)
          .fetchArticleBySlug(widget.slug);
    });
  }

  @override
  void dispose() {
    // Saat halaman ditutup, bersihkan data di controller biar nggak nyangkut
    WidgetsBinding.instance.addPostFrameCallback((_) {
       Provider.of<ArticleController>(context, listen: false).clearSelectedArticle();
    });
    super.dispose();
  }

  /// Fungsi yang dipanggil saat tombol hati ditekan.
  /// Dia cuma ngasih tau controller, "Woi, tombol like di-tap!"
  void _performToggleLike() {
    Provider.of<ArticleController>(context, listen: false)
        .toggleLikeStatus(widget.slug);
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Kembali', style: TextStyle(color: Colors.white)),
      ),
      // Consumer ini yang bikin UI-nya bisa "dengerin" perubahan dari controller
      body: Consumer<ArticleController>(
        builder: (context, controller, child) {
          
          // 1. Tampilan saat Loading
          if (controller.isDetailLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          // 2. Tampilan saat Error
          if (controller.detailErrorMessage != null) {
            return Center(child: Text('Waduh, error: ${controller.detailErrorMessage}'));
          }

          // 3. Tampilan jika data belum siap
          final article = controller.selectedArticle;
          if (article == null) {
            return const Center(child: Text('Artikel tidak ditemukan.'));
          }

          // 4. Tampilan utama jika semua data sudah siap
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Bagian Gambar Artikel Utama ---
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(article.fullCoverPhotoUrl),
                      fit: BoxFit.cover,
                      // Tambahkan fallback jika gambar gagal dimuat
                      onError: (exception, stackTrace) {
                        // Tidak perlu print, cukup tampilkan placeholder
                      },
                    ),
                     color: Colors.grey[900], // Background placeholder
                  ),
                  child: Stack(
                    children: [
                      // Overlay gelap di bawah
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [ Colors.transparent, Colors.black.withOpacity(0.8) ],
                          ),
                        ),
                      ),
                      // --- Like dan Komentar ---
                      Positioned(
                        bottom: 12,
                        left: 20,
                        child: Row(
                          children: [
                            // 1. Tombol Hati yang Cerdas
                            GestureDetector(
                              onTap: controller.isLikingInProgress ? null : _performToggleLike,
                              child: Icon(
                                controller.isLikedByCurrentUser == true ? Icons.favorite : Icons.favorite_border,
                                color: controller.isLikedByCurrentUser == true ? Colors.red : Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // 2. Jumlah Like dari Controller
                            Text(
                              controller.likesCount?.toString() ?? '–',
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 24),
                            // 3. Ikon dan Jumlah Komentar (masih data dummy)
                            const Icon(Icons.mode_comment_outlined, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              '0', // Nanti ini juga dari API
                              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // --- Judul, Tanggal, dan Isi Artikel ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, height: 1.3),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        article.formattedPublishedDate,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),

                // --- Render Konten HTML ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: HtmlWidget(
                    article.body ?? 'Konten tidak tersedia.',
                    textStyle: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
                  ),
                ),

                const SizedBox(height: 30),
                ArticleCommentsSection(articleSlug: article.slug),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}