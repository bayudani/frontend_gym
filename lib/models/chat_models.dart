
class ChatMessage {
  final String text;
  final bool isUserMessage;
  final bool isError; // Untuk nandain kalo itu pesan error

  ChatMessage({
    required this.text,
    required this.isUserMessage,
    this.isError = false,
  });

   // Tambahkan factory constructor ini
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'],
      isUserMessage: json['sender'] == 'user',
    );
  }
}
