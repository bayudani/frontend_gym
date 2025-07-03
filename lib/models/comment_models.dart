// lib/models/comment_model.dart

class Comment {
  final String id;
  final String content; // Diubah dari 'comment' menjadi 'content'
  final String userName;  // Diubah dari object 'User' menjadi 'userName'
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.content,
    required this.userName,
    required this.createdAt,
  });

  // Factory method ini sekarang pas dengan respons GET dari API lo
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id']?.toString() ?? '',
      content: json['content'] ?? 'Komentar tidak tersedia.',
      userName: json['user_name'] ?? 'Anonim',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}