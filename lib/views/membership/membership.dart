// lib/views/membership/membership_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/controllers/membership_controller.dart'; // <-- IMPORT CONTROLLER
import 'package:gym_app/models/membership_models.dart'; // <-- IMPORT MODEL
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';
import 'package:gym_app/views/membership/membership_checkout_page.dart';

// ... (semua const _placeholderImage tetap sama) ...
const _membershipBannerImage = 'assets/images/Carousel.png';
const _barbellProgramImage = 'assets/images/barbell_program.png';
const _dumbbellProgramImage = 'assets/images/dumble.png';
const _megaphoneIconPath = 'assets/images/megaphone_icon.png';
const _dumbbellIconPath = 'assets/images/dumble.png';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  int _selectedIndex = 2;

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
        backgroundColor: Colors.black, // AppBar hitam

        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),

          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Consumer<MembershipController>(
        // <-- GUNAKAN CONSUMER DI SINI
        builder: (context, controller, child) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor:
                    Colors.transparent, // Transparan agar gambar terlihat
                expandedHeight:
                    MediaQuery.of(context).size.height *
                    0.25, // Tinggi 25% dari layar
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gambar latar belakang utama
                      Image.asset(
                        _membershipBannerImage,
                        fit:
                            BoxFit
                                .cover, // Memastikan gambar menutupi seluruh area
                      ),
                      // Gradien Overlay di atas gambar latar belakang
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(
                                0.2,
                              ), // Sedikit transparan
                              Colors.black.withOpacity(
                                0.5,
                              ), // Lebih gelap di bawah
                            ],
                          ),
                        ),
                      ),
                      // Teks "Let's Join Membership"
                      Positioned(
                        // PERBAIKAN: Mengurangi nilai 'top' karena AppBar tidak lagi transparan di belakangnya
                        // Ini akan memposisikan teks relatif terhadap bagian atas FlexibleSpaceBar
                        top: 30, // Posisi teks dari atas FlexibleSpaceBar
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Let\'s Join',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Membership',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Dengan bergabung sebagai anggota\ndi gym anda telah memulai langkah\nawal untuk hidup yang lebih sehat',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Tampilan Loading
              if (controller.isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),

              // Tampilan Error
              if (controller.errorMessage != null)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      controller.errorMessage!,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ),

              // Tampilan jika data berhasil dimuat
              if (!controller.isLoading && controller.errorMessage == null)
                SliverList(
                  delegate: SliverChildListDelegate([
                    // Bagian Discount Banner (tetap sama)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 20.0,
                      ),
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
                              Image.asset(
                                _megaphoneIconPath,
                                width: 35,
                                height: 35,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      '40% discount',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'on all our membership →',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  // color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    _megaphoneIconPath,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // --- DAFTAR MEMBERSHIP DINAMIS ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.separated(
                        itemCount: controller.plans.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final plan = controller.plans[index];
                          // Ganti-gantian gambar biar cakep
                          final imagePath = _dumbbellProgramImage;

                          return _buildMembershipOptionCard(
                            context,
                            plan: plan, // Kirim object plan lengkap
                            imagePath: imagePath,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ]),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // --- Widget Kartu Di-upgrade untuk menerima object MembershipPlan ---
  Widget _buildMembershipOptionCard(
    BuildContext context, {
    required MembershipPlan plan, // <-- Menerima object plan
    required String imagePath,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 30, 30, 30),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plan.name, // <-- Data dari API
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                plan.formattedDuration, // <-- Data dari API (getter)
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Text(
                plan.formattedPrice, // <-- Data dari API (getter)
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MembershipCheckoutPage(
                            membershipType: plan.name,
                            membershipPrice: plan.formattedPrice,
                          ),
                    ),
                  );
                },
                child: const Text(
                  'Join membership →',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Image.asset(imagePath, width: 80, height: 80, fit: BoxFit.contain),
        ],
      ),
    );
  }
}
