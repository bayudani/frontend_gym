
class ChatMessage {
  final String text;
  final bool isUserMessage;
  final bool isError; // Untuk nandain kalo itu pesan error

  ChatMessage({
    required this.text,
    required this.isUserMessage,
    this.isError = false,
  });
}
