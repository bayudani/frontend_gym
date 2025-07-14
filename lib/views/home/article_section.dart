import 'package:flutter/material.dart';
import 'package:gym_app/controllers/article_controller.dart';
import 'package:gym_app/models/article_models.dart';
import 'package:gym_app/views/blog/blog_page.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/views/blog/article_detail_page.dart';

class ArticleSection extends StatelessWidget {
  const ArticleSection({super.key});

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BlogPage()),
                  );
                },
                child: const Text(
                  'See all',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Consumer<ArticleController>(
            builder: (context, controller, child) {
              if (controller.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              if (controller.errorMessage != null) {
                return Center(
                  child: Text(
                    controller.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              if (controller.latestArticles.isEmpty) {
                return const Center(
                  child: Text(
                    'Tidak ada artikel.',
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }
              return Column(
                children:
                    controller.latestArticles.map((article) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: _buildArticleCard(
                          context: context,
                          article: article,
                        ),
                      );
                    }).toList(),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildArticleCard({
    required BuildContext context,
    required Article article,
  }) {
    final imageUrl = article.fullCoverPhotoUrl;
    print("Mencoba memuat gambar dari URL: $imageUrl");
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailPage(slug: article.slug),
          ),
        );
      },
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {
              print('Gagal memuat gambar: ${article.fullCoverPhotoUrl}');
            },
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
          borderRadius: BorderRadius.circular(15),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    article.formattedPublishedDate,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                article.title,
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
}
