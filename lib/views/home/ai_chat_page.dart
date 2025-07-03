// views/ai/ai_chat_page.dart

import 'package:flutter/material.dart';
import 'package:gym_app/controllers/ai_controller.dart';
import 'package:gym_app/models/chat_models.dart';
import 'package:gym_app/views/home/ai_form_checker_page.dart';
import 'package:provider/provider.dart';

// 1. UBAH JADI STATEFULWIDGET
class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController textController = TextEditingController();

  // 2. PANGGIL FETCH HISTORY DI initState
  @override
  void initState() {
    super.initState();
    // Panggil sekali saja saat widget pertama kali dibuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AiController>(context, listen: false).fetchHistory();
    });
  }

  // Pindahkan handleSend keluar dari build method
  void handleSend() {
    final aiController = Provider.of<AiController>(context, listen: false);
    if (textController.text.trim().isNotEmpty) {
      aiController.sendMessage(textController.text);
      textController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  // 3. JANGAN LUPA PANGGIL DISPOSE
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "FitID AI Assistant",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1c1c1e),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        // --- 2. TAMBAHKAN TOMBOL AKSI DI SINI ---
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
            tooltip: 'Cek Form Latihan',
            onPressed: () {
              // Navigasi ke halaman AI Form Checker
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AiFormCheckerPage(),
                ),
              );
            },
          ),
        ],
        // --- Akhir dari tambahan ---
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<AiController>(
              builder: (context, controller, child) {
                // Tampilkan loading di tengah saat pertama kali fetch
                if (controller.isLoading && controller.messages.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  );
                }
                // Tampilkan pesan "Mulai Percakapan" jika kosong setelah fetch
                if (controller.messages.isEmpty) {
                  return const Center(
                    child: Text(
                      "Mulai percakapanmu dengan FitID AI!",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  );
                }
                // Tampilkan ListView seperti biasa
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  reverse: true, // <-- Penting untuk chat
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        controller.messages.reversed.toList()[index];
                    return _ChatBubble(message: message);
                  },
                );
              },
            ),
          ),
          // Bagian input text dan tombol send
          Consumer<AiController>(
            builder: (context, controller, child) {
              if (controller.isLoading) {
                return const Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "FitID AI is typing...",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1c1c1e),
              border: Border(top: BorderSide(color: Colors.grey[800]!)),
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
                        icon: Icon(
                          Icons.send,
                          color:
                              controller.isLoading ? Colors.grey : Colors.red,
                        ),
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

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color:
              message.isError
                  ? Colors.red[900]
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
