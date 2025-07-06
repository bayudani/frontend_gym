import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:gym_app/controllers/profile_controller.dart';
import 'package:gym_app/controllers/item_rewards_controller.dart';
import 'package:gym_app/models/item_rewards_models.dart';
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';
import 'package:gym_app/widget/point/reward_history_page.dart';

// --- Definisi Gambar dan Ikon ---
const String _pointIcon = 'assets/images/coin_stack.png';
const String _historyIcon = 'assets/images/history.png';

class PointPage extends StatefulWidget {
  const PointPage({super.key});

  @override
  State<PointPage> createState() => _PointPageState();
}

class _PointPageState extends State<PointPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Memuat data saat halaman pertama kali dibuka
      Provider.of<RewardController>(context, listen: false).fetchRewards();
      Provider.of<ProfileController>(
        context,
        listen: false,
      ).fetchProfile(context);
      Provider.of<ProfileController>(
        context,
        listen: false,
      ).fetchPoint(context);
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
      body: RefreshIndicator(
        onRefresh: () async {
          // Fungsi refresh untuk swipe-down
          await Provider.of<RewardController>(
            context,
            listen: false,
          ).fetchRewards();
          // ignore: use_build_context_synchronously
          await Provider.of<ProfileController>(
            context,
            listen: false,
          ).fetchPoint(context);
        },
        color: Colors.white,
        backgroundColor: Colors.red,
        child: CustomScrollView(
          slivers: [
            _buildHeader(context),
            Consumer<RewardController>(
              builder: (context, controller, child) {
                if (controller.isLoading && controller.rewards.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                }
                if (controller.errorMessage != null &&
                    controller.rewards.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          controller.errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  );
                }
                if (controller.rewards.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        "Belum ada reward yang tersedia.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  );
                }
                return _buildRewardGrid(context, controller.rewards);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, profile, child) {
        final userName = profile.userProfile?.name ?? 'Guest';
        final userPoints = profile.userPoint?.point ?? 0;
        final formattedPoints = NumberFormat.decimalPattern(
          'id_ID',
        ).format(userPoints);

        return SliverAppBar(
          backgroundColor: Colors.black,
          expandedHeight: 250,
          pinned: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF8B0000), Color(0xFFE53935)],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top:
                        MediaQuery.of(context).padding.top +
                        kToolbarHeight * 0.7,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hello',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top:
                        MediaQuery.of(context).padding.top +
                        kToolbarHeight * 0.7 +
                        60,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(_pointIcon, width: 20, height: 20),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    '$formattedPoints Points',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RewardHistoryPage(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  _historyIcon,
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'History',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRewardGrid(BuildContext context, List<RewardItem> rewards) {
    final isClaiming = context.watch<RewardController>().isClaiming;

    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.7,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final reward = rewards[index];
          return _buildRewardCard(
            context: context,
            reward: reward,
            isClaiming: isClaiming,
            onClaim: () async {
              final controller = Provider.of<RewardController>(
                context,
                listen: false,
              );
              final error = await controller.claimReward(context, reward.id);

              if (!context.mounted) return;

              if (error == null) {
                // showClaimSuccessPopup(context, reward.name);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RewardHistoryPage(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
          );
        }, childCount: rewards.length),
      ),
    );
  }

  // --- WIDGET CARD REWARD DENGAN LAYOUT BARU ---
  Widget _buildRewardCard({
    required BuildContext context,
    required RewardItem reward,
    required bool isClaiming,
    required VoidCallback onClaim,
  }) {
    final imageUrl = reward.fullImageUrl;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {},
                ),
              ),
            ),
          ),
          // Bagian bawah kartu
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  reward.formattedPoints,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Spacer untuk mendorong tombol ke bawah jika ada sisa ruang
          const Spacer(),
          // Tombol Klaim
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: ElevatedButton(
              onPressed: isClaiming ? null : onClaim,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                // Padding vertikal untuk tinggi tombol
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child:
                  isClaiming
                      ? const SizedBox(
                        height: 20, // Sesuaikan tinggi progress indicator
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Text(
                        'Klaim',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
