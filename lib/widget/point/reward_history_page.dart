// lib/views/point/reward_history_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/controllers/reward_history_controller.dart';
import 'package:gym_app/models/RewardHistoryItem_models.dart'; // Pastikan nama file ini benar
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';

class RewardHistoryPage extends StatefulWidget {
  const RewardHistoryPage({super.key});

  @override
  State<RewardHistoryPage> createState() => _RewardHistoryPageState();
}

class _RewardHistoryPageState extends State<RewardHistoryPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RewardHistoryController>(
        context,
        listen: false,
      ).fetchHistory();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Riwayat Reward',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Consumer<RewardHistoryController>(
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
                  style: const TextStyle(color: Colors.white70),
                ),
              );
            }

            if (controller.history.isEmpty) {
              return const Center(
                child: Text(
                  "Kamu belum punya histori reward.",
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.fetchHistory(),
              color: Colors.white,
              backgroundColor: Colors.red,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20.0,
                ),
                itemCount: controller.history.length,
                itemBuilder: (context, index) {
                  final record = controller.history[index];
                  return _buildRewardHistoryCard(record);
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // --- Widget kartu riwayat yang sudah siap menangani gambar null ---
  Widget _buildRewardHistoryCard(RewardHistoryItem record) {
    final imageUrl = record.fullImageUrl; // Ini bisa jadi null

    Color statusColor;
    FontWeight statusFontWeight = FontWeight.w500; // Default weight

    if (record.status.toLowerCase() == 'claimed') {
      statusColor = Colors.greenAccent[400]!; // Warna hijau untuk 'claimed'
      statusFontWeight = FontWeight.bold; // Buat tebal biar lebih menonjol
    } else if (record.status.toLowerCase() == 'pending') {
      statusColor = Colors.red!; // Warna kuning/amber untuk 'pending'
    } else {
      statusColor = Colors.white70; // Warna default jika ada status lain
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            // Cek apakah imageUrl ada atau tidak
            child:
                imageUrl != null
                    ? Image.network(
                      // Jika ada, tampilkan gambar dari network
                      imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[850],
                          child: const Icon(
                            Icons.broken_image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                    : Container(
                      // Jika tidak ada, tampilkan container dengan ikon
                      width: 60,
                      height: 60,
                      color: Colors.grey[850],
                      child: const Icon(
                        Icons.card_giftcard,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  record.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  record.formattedDateTime,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            record.status,
            style: TextStyle(
              color: statusColor, // <-- Warnanya sekarang dinamis
              fontSize: 14,
              fontWeight:
                  statusFontWeight, // <-- Ketebalan font juga bisa dinamis
            ),
          ),
        ],
      ),
    );
  }
}
