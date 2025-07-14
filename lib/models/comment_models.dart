class Comment {
  final String id;
  final String content;
  final String userName;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.content,
    required this.userName,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id']?.toString() ?? '',
      content: json['content'] ?? 'Komentar tidak tersedia.',
      userName: json['user_name'] ?? 'Anonim',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
