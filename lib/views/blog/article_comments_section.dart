import 'package:flutter/material.dart';

// Style border input field untuk komentar
const _commentOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.transparent), // Tidak ada border terlihat
  borderRadius: BorderRadius.all(Radius.circular(10)),
);

class ArticleCommentsSection extends StatefulWidget {
  final List<Map<String, String>> comments; // Daftar komentar

  const ArticleCommentsSection({
    super.key,
    required this.comments,
  });

  @override
  State<ArticleCommentsSection> createState() => _ArticleCommentsSectionState();
}

class _ArticleCommentsSectionState extends State<ArticleCommentsSection> {
  final TextEditingController _commentController = TextEditingController();

  // Widget untuk setiap kartu komentar
  Widget _buildCommentCard(Map<String, String> comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.black, // PERBAIKAN: Latar belakang komentar menjadi hitam
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey[700],
                child: Text(
                  comment['user']![0].toUpperCase(), // Huruf pertama nama user
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                comment['user']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                comment['time']!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment['comment']!,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container( // PERBAIKAN: Mengganti Padding dengan Container untuk background
      color: const Color(0xFF262626), // Latar belakang abu-abu gelap untuk seluruh bagian komentar
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PERBAIKAN: Handle (garis) di bagian atas komentar
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 5,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(bottom: 15),
            ),
          ),
          // PERBAIKAN: Judul "Komentar" dengan jumlah komentar di sebelahnya
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Untuk menyelaraskan jumlah komentar ke kanan
            children: [
              const Text(
                'Komentar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${widget.comments.length}', // Menampilkan jumlah komentar
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18, // Ukuran font disesuaikan dengan gambar
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Daftar Komentar
          ...widget.comments.map((comment) => _buildCommentCard(comment)).toList(),
          const SizedBox(height: 20),
          // PERBAIKAN: Input "Tambahkan komentar" sebagai TextFormField
          TextFormField(
            controller: _commentController,
            style: const TextStyle(color: Colors.white), // Warna teks input
            decoration: InputDecoration(
              hintText: 'Tambahkan komentar',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF333333), // Warna background input field
              border: _commentOutlineInputBorder, // Border transparan
              enabledBorder: _commentOutlineInputBorder,
              focusedBorder: _commentOutlineInputBorder.copyWith(
                borderSide: const BorderSide(color: Colors.red), // Border merah saat fokus
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              // Icon profil di sebelah kiri
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey[700], // Background avatar
                  child: Text(
                    'J', // Huruf pertama pengguna saat ini (placeholder)
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
            onFieldSubmitted: (value) {
              // Logika ketika komentar dikirim (misalnya tekan Enter)
              if (value.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Komentar "${_commentController.text}" dikirim!')),
                );
                _commentController.clear();
                // Di sini Anda akan menambahkan logika untuk menyimpan komentar ke daftar komentar
              }
            },
          ),
        ],
      ),
    );
  }
}
