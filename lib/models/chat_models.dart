class ChatMessage {
  final String text;
  final bool isUserMessage;
  final bool isError;

  ChatMessage({
    required this.text,
    required this.isUserMessage,
    this.isError = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'],
      isUserMessage: json['sender'] == 'user',
    );
  }
}
