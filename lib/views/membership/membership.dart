// lib/views/membership/membership_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/controllers/membership_controller.dart'; // <-- IMPORT CONTROLLER
import 'package:gym_app/models/membership_models.dart'; // <-- IMPORT MODEL
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';
import 'package:gym_app/views/membership/membership_checkout_page.dart';
import 'package:gym_app/views/home/home_page.dart'; // <-- IMPORT HOME PAGE

// Definisi gambar dan ikon yang digunakan
const _membershipBannerImage = 'assets/images/Carousel.png';
const _barbellProgramImage = 'assets/images/barbell_program.png';
const _dumbbellProgramImage = 'assets/images/3d.png'; // Updated to 3d.png
const _megaphoneIconPath = 'assets/images/megaphone_icon.png';
const _dumbbellIconPath =
    'assets/images/dumble.png'; // Ini bisa digunakan di tempat lain jika diperlukan, saat ini dipakai di banner diskon

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  int _selectedIndex = 2; // Asumsi Membership ada di indeks 2 di bottom nav bar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Widget untuk Kartu Opsi Membership
  // Ini adalah definisi satu-satunya dari _buildMembershipOptionCard yang seharusnya ada
  Widget _buildMembershipOptionCard(
    BuildContext context, {
    required MembershipPlan plan, // Menerima object plan lengkap
    required String imagePath, // Parameter untuk path gambar ikon
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(
          255,
          30,
          30,
          30,
        ), // Warna latar belakang kartu
        borderRadius: BorderRadius.circular(15), // Sudut membulat kartu
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plan.name, // Nama membership dari data API
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                plan.formattedDuration, // Durasi membership (sudah diformat)
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Text(
                plan.formattedPrice, // Harga membership (sudah diformat)
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  // Mengambil ID plan dari objek plan
                  final String planId = plan.id;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MembershipCheckoutPage(
                        membershipId: planId, // Meneruskan ID plan
                        // Jika MembershipCheckoutPage masih membutuhkan, tambahkan juga:
                        // membershipType: plan.name,
                        // membershipPrice: plan.formattedPrice,
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
          // Container untuk gambar ikon membership dengan background yang diubah
          Container(
            width: 80, // Lebar container untuk gambar
            height: 80, // Tinggi container untuk gambar
            decoration: BoxDecoration(
              color: const Color(0xFF424242), // BACKGROUND DIUBAH DI SINI
              borderRadius: BorderRadius.circular(10), // Sudut membulat
            ),
            child: Center(
              // Pusatkan gambar di dalam container
              child: Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ), // Ukuran gambar di dalam container
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Latar belakang utama halaman

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            // Cek dulu apakah bisa kembali (pop)
            if (Navigator.canPop(context)) {
              // Jika ya, kembali ke halaman sebelumnya
              Navigator.pop(context);
            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        title: const Text(
          'Membership',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<MembershipController>(
        builder: (context, controller, child) {
          return CustomScrollView(
            slivers: [
              // SliverAppBar untuk banner di bagian atas halaman
              SliverAppBar(
                backgroundColor:
                    Colors.transparent, // Transparan agar gambar terlihat
                expandedHeight: MediaQuery.of(context).size.height *
                    0.25, // Tinggi banner 25% dari layar
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gambar latar belakang utama banner
                      Image.asset(
                        _membershipBannerImage,
                        fit: BoxFit.cover, // Memastikan gambar menutupi seluruh area
                      ),
                      // Gradien Overlay di atas gambar latar belakang untuk efek visual
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(
                                0.2,
                              ), // Sedikit transparan di atas
                              Colors.black.withOpacity(
                                0.5,
                              ), // Lebih gelap di bawah
                            ],
                          ),
                        ),
                      ),
                      // Teks "Let's Join Membership" di atas banner
                      Positioned(
                        top: 30, // Posisi teks dari atas FlexibleSpaceBar
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Let\'s Join',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Membership',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
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

              // Kondisional untuk menampilkan Loading, Error, atau Data
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
                    // Bagian Discount Banner
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
                              colors: [
                                Color(0xFFE53935),
                                Color(0xFF8B0000),
                              ], // Gradient merah
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Ikon Megaphone (sesuai kode awal)
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
                                      'on all our membership',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Container untuk gambar dumbbell dengan background putih
                              Container(
                                width: 65,
                                height: 65,
                                // decoration: BoxDecoration(
                                //    color: Colors.white, // Background putih
                                //    borderRadius: BorderRadius.circular(10),
                                // ),
                                child: Center(
                                  child: Image.asset(
                                    _dumbbellIconPath, // Gambar dumbbell untuk banner ini
                                    width: 55,
                                    height: 55,
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
                          final plan =
                              controller.plans[index]; // Perbaikan spasi
                          // Selalu gunakan gambar dumbbell untuk semua kartu membership
                          final imagePath = _dumbbellProgramImage;

                          return _buildMembershipOptionCard(
                            context,
                            plan: plan, // Meneruskan objek plan lengkap
                            imagePath:
                                imagePath, // Meneruskan path gambar dumbbell
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20), // Spasi di bagian bawah daftar
                  ]),
                ),
            ],
          );
        },
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}