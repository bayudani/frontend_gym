// lib/views/home/home_page.dart

import 'package:flutter/material.dart';
import 'package:gym_app/controllers/profile_controller.dart';
import 'package:gym_app/views/home/ai_chat_page.dart';
import 'package:gym_app/views/membership/membership.dart'; // <-- Pastikan ini di-import
import 'package:gym_app/views/home/article_section.dart';
import 'package:gym_app/views/home/choose_program_section.dart';
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';
import 'package:gym_app/widget/point/point_page.dart';
import 'package:provider/provider.dart';

const _dumbbellIconPath = 'assets/images/dumble.png';
const _megaphoneIconPath = 'assets/images/megaphone_icon.png';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<ProfileController>(context, listen: false);
      controller.fetchProfile(context);
      controller.fetchPoint(context);
      // PERUBAHAN: Panggil juga data member saat home dibuka
      controller.fetchMemberData(context);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // --- FUNGSI LOGIKA UNTUK GERBANG AI ---
  void _handleAiChatTap() {
    final profileController = Provider.of<ProfileController>(context, listen: false);

    // Cek status member aktif
    if (profileController.isMemberActive) {
      // Jika aktif, gaskeun ke AI Chat
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AiChatPage()),
      );
    } else {
      // Jika tidak aktif, tampilkan dialog
      _showMembershipRequiredDialog();
    }
  }

  void _showMembershipRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2c2c2e),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Row(
            children: [
              // Icon(Icons.star, color: Colors.amber, size: 28),
              SizedBox(width: 10),
              Text('Fitur Khusus Member', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            'Fitur AI Assistant hanya bisa diakses oleh member aktif. Yuk, gabung sekarang untuk dapatkan benefit lengkapnya!',
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Nanti Saja', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Jadi Member', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MembershipPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }
  // --- AKHIR DARI FUNGSI LOGIKA ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        // PERUBAHAN: Panggil _handleAiChatTap, bukan navigasi langsung
        onPressed: _handleAiChatTap,
        backgroundColor: Colors.red,
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
        tooltip: 'Konsultasi dengan AI',
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color.fromARGB(255, 30, 30, 30), Colors.black],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 60.0, left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Hello', style: TextStyle(color: Colors.white70, fontSize: 18)),
                              Consumer<ProfileController>(
                                builder: (context, profileController, child) {
                                  if (profileController.isLoading) {
                                    return const Text('Loading...', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold));
                                  }
                                  final userName = profileController.userProfile?.name ?? 'Guest';
                                  return Text(userName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold));
                                },
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const PointPage()));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Points', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                  Consumer<ProfileController>(
                                    builder: (context, profileController, child) {
                                      if (profileController.isPointLoading) {
                                        return const Text('...', style: TextStyle(color: Colors.yellow, fontSize: 14, fontWeight: FontWeight.bold));
                                      }
                                      final points = profileController.userPoint?.point ?? 0;
                                      return Text(points.toString(), style: const TextStyle(color: Colors.yellow, fontSize: 14, fontWeight: FontWeight.bold));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Let's start your day",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFFE53935), Color(0xFF8B0000)],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(_megaphoneIconPath, width: 35, height: 35),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('40% discount', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              // ===============================================
                              // PERUBAHAN DI SINI: Membungkus teks dengan GestureDetector
                              GestureDetector(
                                onTap: () {
                                  // Navigasi ke halaman MembershipPage
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MembershipPage(), // Pastikan MembershipPage diimport
                                    ),
                                  );
                                },
                                child: const Text('on all our membership →', style: TextStyle(color: Colors.white70, fontSize: 14)),
                              ),
                              // ===============================================
                            ],
                          ),
                        ),
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Image.asset(_dumbbellIconPath, width: 50, height: 50, fit: BoxFit.contain),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const ChooseProgramSection(),
              const ArticleSection(),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}