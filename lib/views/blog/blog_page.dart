// lib/views/blog/blog_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/controllers/article_controller.dart';
import 'package:gym_app/models/article_models.dart';
import 'package:gym_app/views/blog/article_detail_page.dart'; // <-- PENTING: Import halaman detail
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // --- WIDGET KARTU ARTIKEL YANG SUDAH DI-UPGRADE ---
  Widget _buildArticleCard({
    required BuildContext context,
    required Article article, // <-- Sekarang menerima object Article lengkap
  }) {
    return GestureDetector( // <-- DIBUNGKUS DENGAN GESTUREDETECTOR
      onTap: () {
        // --- INI DIA LOGIC NAVIGASINYA ---
        Navigator.push(
          context,
          MaterialPageRoute(
            // Kirim slug-nya ke ArticleDetailPage
            builder: (context) => ArticleDetailPage(slug: article.slug),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        height: 180,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(article.fullCoverPhotoUrl), // <-- Dari model
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
            onError: (exception, stackTrace) {
              print('Error loading image: $exception');
            },
          ),
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[800],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    article.formattedPublishedDate, // <-- Dari model
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Text(
                article.title, // <-- Dari model
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
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        title: const Text(
          'Artikel Blog',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<ArticleController>(
        builder: (context, controller, child) {
          // (Tampilan loading, error, empty tetap sama persis)
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if (controller.errorMessage != null) {
            return Center(child: Text('Oops! ${controller.errorMessage}'));
          }
          if (controller.articles.isEmpty) {
            return const Center(child: Text('Belum ada artikel.'));
          }

          // --- TAMPILAN LISTVIEW BUILDER ---
          return ListView.builder(
            itemCount: controller.articles.length,
            itemBuilder: (context, index) {
              final Article article = controller.articles[index];
              return _buildArticleCard(
                context: context,
                article: article, // <-- Kirim seluruh object article
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