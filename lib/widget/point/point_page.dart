// lib/widget/point/point_page.dart

import 'package:flutter/material.dart';
import 'package:gym_app/controllers/profile_controller.dart';
import 'package:gym_app/controllers/item_rewards_controller.dart';
import 'package:gym_app/models/item_rewards_models.dart';
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';
import 'package:gym_app/widget/point/claim_reward_popup.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// --- Placeholder Images ---
const _pointIcon = 'assets/images/coin_stack.png';
const _HistoryIcon = 'assets/images/history.png';
const _ribbonIcon = 'assets/images/ribbon.png';
const _redGiftBoxImage = 'assets/images/red_gift_box.png';
const _membershipBannerImage = 'assets/images/coooo.png';


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
      Provider.of<RewardController>(context, listen: false).fetchRewards();
      Provider.of<ProfileController>(context, listen: false).fetchProfile(context);
      Provider.of<ProfileController>(context, listen: false).fetchPoint(context);
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
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
          Consumer<RewardController>(
            builder: (context, controller, child) {
              if (controller.isLoading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: Colors.white)),
                );
              }
              if (controller.errorMessage != null) {
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
        final formattedPoints = NumberFormat.decimalPattern('id_ID').format(userPoints);

        return SliverAppBar(
          backgroundColor: Colors.black,
          expandedHeight: 250,
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
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 60,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Hello', style: TextStyle(color: Colors.white70, fontSize: 18)),
                        Text(
                          userName,
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 130,
                    left: 20,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Image.asset(_pointIcon, width: 20, height: 20,),
                              const SizedBox(width: 5),
                              Text('$formattedPoints Points', style: const TextStyle(color: Colors.white, fontSize: 14)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Image.asset(_HistoryIcon, width: 20, height: 20,),
                              const SizedBox(width: 5),
                              Text('History', style: const TextStyle(color: Colors.white, fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset(_redGiftBoxImage, height: 20, fit: BoxFit.contain),
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
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.7,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final reward = rewards[index];
            return _buildRewardCard(
              reward: reward,
              onClaim: () {
                showClaimSuccessPopup(context, reward.name);
              },
            );
          },
          childCount: rewards.length,
        ),
      ),
    );
  }

  Widget _buildRewardCard({
    required RewardItem reward,
    required VoidCallback onClaim,
  }) {
    final imageUrl = reward.fullImageUrl;
    print("Mencoba memuat gambar reward dari: $imageUrl");

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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    print('Gagal memuat gambar reward: $imageUrl, error: $exception');
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          reward.formattedPoints,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: onClaim,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          minimumSize: Size.zero,
                        ),
                        child: const Text('Klaim', style: TextStyle(fontSize: 12)),
                      ),
                    ],
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
