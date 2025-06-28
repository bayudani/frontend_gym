import 'package:flutter/material.dart';
import 'package:gym_app/controllers/ai_controller.dart';
import 'package:gym_app/models/chat_models.dart';
import 'package:provider/provider.dart';

class AiChatPage extends StatelessWidget {
  const AiChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller untuk text field
    final TextEditingController textController = TextEditingController();
    
    // Fungsi untuk menghandle pengiriman pesan
    void handleSend() {
      // Ambil AiController dari Provider
      final aiController = Provider.of<AiController>(context, listen: false);
      if (textController.text.trim().isNotEmpty) {
        // Panggil fungsi sendMessage dari controller
        aiController.sendMessage(textController.text);
        textController.clear();
        FocusScope.of(context).unfocus(); // Tutup keyboard setelah kirim
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "FitID AI Assistant",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1c1c1e), // Warna app bar yang sedikit beda
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Bagian untuk menampilkan daftar chat
          Expanded(
            child: Consumer<AiController>(
              builder: (context, controller, child) {
                // Gunakan ListView.builder untuk efisiensi
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  reverse: true, // Membuat chat terbaru selalu di bawah
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    // Balik urutan list agar pesan terbaru muncul di paling bawah
                    final message = controller.messages.reversed.toList()[index];
                    return _ChatBubble(message: message);
                  },
                );
              },
            ),
          ),

          // Tampilkan indikator "AI is typing..." jika sedang loading
          Consumer<AiController>(
            builder: (context, controller, child) {
              if (controller.isLoading) {
                return const Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  child: Row(
                    children: [
                      SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                      SizedBox(width: 12),
                      Text("FitID AI is typing...", style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink(); // Tampilkan widget kosong jika tidak loading
            },
          ),

          // Bagian untuk input teks
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1c1c1e),
              border: Border(top: BorderSide(color: Colors.grey[800]!))
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration.collapsed(
                        hintText: "Tanya apa saja seputar fitness...",
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                      onSubmitted: (_) => handleSend(),
                    ),
                  ),
                  Consumer<AiController>(
                    builder: (context, controller, child) {
                      return IconButton(
                        icon: Icon(Icons.send, color: controller.isLoading ? Colors.grey : Colors.red),
                        // Nonaktifkan tombol saat sedang loading
                        onPressed: controller.isLoading ? null : handleSend,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget terpisah untuk gelembung chat agar lebih rapi
class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      // Atur posisi bubble chat (kanan untuk user, kiri untuk AI)
      alignment: message.isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isError
            ? Colors.red[900] // Warna khusus untuk pesan error
            : message.isUserMessage
                ? Colors.red
                : const Color(0xFF2c2c2e),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message.text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

