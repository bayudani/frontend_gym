// lib/views/blog/article_comments_section.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago; // Package untuk format waktu "5 menit lalu"
import 'package:gym_app/controllers/comment_controller.dart';
import 'package:gym_app/models/comment_models.dart';

// Tambahkan inisialisasi locale timeago di main.dart jika belum
// timeago.setLocaleMessages('id', timeago.IdMessages());

class ArticleCommentsSection extends StatefulWidget {
  final String articleSlug;

  const ArticleCommentsSection({
    super.key,
    required this.articleSlug,
  });

  @override
  State<ArticleCommentsSection> createState() => _ArticleCommentsSectionState();
}

class _ArticleCommentsSectionState extends State<ArticleCommentsSection> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set locale default untuk timeago
    timeago.setLocaleMessages('id', timeago.IdMessages());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CommentController>(context, listen: false)
          .fetchComments(widget.articleSlug);
    });
  }

  void _submitComment() async {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    final success = await Provider.of<CommentController>(context, listen: false)
        .postComment(widget.articleSlug, commentText);

    if (success && mounted) {
      _commentController.clear();
      FocusScope.of(context).unfocus();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Oops! Gagal mengirim komentar.')),
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
  
  // --- Widget Kartu Komentar, Disesuaikan dengan Model Baru ---
  Widget _buildCommentCard(Comment comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[800],
                child: Text(
                  comment.userName.isNotEmpty ? comment.userName[0].toUpperCase() : 'A',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userName,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      timeago.format(comment.createdAt, locale: 'id'),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment.content,
            style: const TextStyle(color: Colors.white70, height: 1.4),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentController>(
      builder: (context, controller, child) {
        return Container(
          color: const Color(0xFF1A1A1A), // Warna background sedikit beda
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40), // Padding bawah lebih besar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... (Handle & Judul "Komentar") ...
              Row(
                children: [
                  const Text('Komentar', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Text('${controller.comments.length}', style: TextStyle(color: Colors.grey[400], fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),

              // --- Input Field Komentar ---
              TextFormField(
                controller: _commentController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Tulis komentarmu...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: const Color(0xFF262626),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon: IconButton(
                    icon: controller.isPosting
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                        : Icon(Icons.send, color: Colors.grey[400]),
                    onPressed: controller.isPosting ? null : _submitComment,
                  ),
                ),
                onFieldSubmitted: (_) => controller.isPosting ? null : _submitComment(),
              ),
              const SizedBox(height: 25),

              // --- Daftar Komentar atau Loading/Empty State ---
              if (controller.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(child: CircularProgressIndicator(color: Colors.white)),
                )
              else if (controller.comments.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(child: Text('Jadilah yang pertama berkomentar!', style: TextStyle(color: Colors.grey))),
                )
              else
                ListView.builder(
                  itemCount: controller.comments.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final comment = controller.comments[index];
                    return _buildCommentCard(comment);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}