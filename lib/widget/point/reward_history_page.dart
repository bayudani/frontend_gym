import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/controllers/reward_history_controller.dart';
import 'package:gym_app/models/RewardHistoryItem_models.dart';
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';
import 'package:gym_app/widget/point/claim_reward_popup.dart';

class RewardHistoryPage extends StatefulWidget {
  const RewardHistoryPage({super.key});

  @override
  State<RewardHistoryPage> createState() => _RewardHistoryPageState();
}

class _RewardHistoryPageState extends State<RewardHistoryPage> {
  int _selectedIndex = 0;
  final Set<String> _loadingClaimIds = {};

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
      body: Consumer<RewardHistoryController>(
        builder: (context, controller, child) {
          if (controller.isLoading && _loadingClaimIds.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (controller.errorMessage != null && controller.history.isEmpty) {
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
                return _buildRewardHistoryCard(context, record);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildRewardHistoryCard(
    BuildContext context,
    RewardHistoryItem record,
  ) {
    final imageUrl = record.fullImageUrl;
    final bool isLoading = _loadingClaimIds.contains(record.id);

    Color statusColor;
    String statusText = record.status.toUpperCase();
    FontWeight statusFontWeight = FontWeight.bold;

    switch (record.status.toLowerCase()) {
      case 'claimed':
        statusColor = Colors.greenAccent[400]!;
        break;
      case 'pending':
        statusColor = Colors.orangeAccent;
        break;
      case 'rejected':
        statusColor = Colors.redAccent;
        break;
      case 'confirmed':
        statusColor = Colors.blueAccent;
        statusText = "SIAP DIAMBIL";
        break;
      default:
        statusColor = Colors.white70;
        statusFontWeight = FontWeight.normal;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    imageUrl != null
                        ? Image.network(
                          imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[850],
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                        )
                        : Container(
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
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 14,
                  fontWeight: statusFontWeight,
                ),
              ),
            ],
          ),

          if (record.status.toLowerCase() == 'confirmed')
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed:
                      isLoading
                          ? null
                          : () async {
                            setState(() {
                              _loadingClaimIds.add(record.id);
                            });

                            try {
                              await Provider.of<RewardHistoryController>(
                                context,
                                listen: false,
                              ).finalizeReward(record.id);

                              if (mounted) {
                                showClaimSuccessPopup(context, record.name);
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _loadingClaimIds.remove(record.id);
                                });
                              }
                            }
                          },
                  child:
                      isLoading
                          ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                          : const Text(
                            'Konfirmasi Telah Diterima',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
