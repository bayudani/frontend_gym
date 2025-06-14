import 'package:flutter/material.dart';
// Removed unused imports as CustomBottomNavBar and its related navigation are removed
// import 'package:gym_app/views/home/home_page.dart';
// import 'package:gym_app/views/profile/profile_page.dart';
// import 'package:gym_app/widgets/custom_bottom_nav_bar.dart';

class MembershipCardPage extends StatefulWidget {
  const MembershipCardPage({super.key});

  // Placeholder for QR Code image. In a real app, this would be generated from memberId.
  static const String _qrCodePlaceholder = 'assets/images/qr_code_placeholder.png'; 
  // _barcodePlaceholder is removed as the barcode part is no longer visible on the card.
  // static const String _barcodePlaceholder = 'assets/images/barcode_placeholder.png'; 

  @override
  State<MembershipCardPage> createState() => _MembershipCardPageState();
}

class _MembershipCardPageState extends State<MembershipCardPage> {
  // Removed _selectedIndex and _onItemTapped as BottomNavigationBar is no longer present.
  // int _selectedIndex = 2;

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  //   // Navigation logic is now handled by CustomBottomNavBar internally.
  //   // No direct Navigator.pushReplacement calls are needed here.
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background hitam
      appBar: AppBar(
        backgroundColor: Colors.black, // AppBar hitam
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: const Text(
          'Kartu Membership',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView( // Tambahkan SingleChildScrollView agar bisa discroll
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                height: 250, // Tinggi kartu
                decoration: BoxDecoration(
                  color: const Color(0xFF262626), // Abu-abu gelap untuk dasar kartu
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Bagian utama kartu (merah)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 170, // Tinggi bagian merah
                        decoration: const BoxDecoration(
                          color: Color(0xFFE53935), // Merah cerah
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                        ),
                      ),
                    ),
                    // Bagian abu-abu di sudut kanan atas merah
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 140, // Lebar bagian abu-abu
                        height: 100, // Tinggi bagian abu-abu
                        decoration: const BoxDecoration(
                          color: Color(0xFF262626), // Abu-abu gelap
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(70), // Sudut melengkung
                          ),
                        ),
                      ),
                    ),
                    // Tiga titik di kanan atas (diposisikan ulang agar masuk area abu-abu)
                    Positioned(
                      top: 15,
                      right: 15, // Disesuaikan agar lebih ke kanan
                      child: Row(
                        children: [
                          Container(width: 5, height: 5, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                          const SizedBox(width: 5),
                          Container(width: 5, height: 5, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                          const SizedBox(width: 5),
                          Container(width: 5, height: 5, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                        ],
                      ),
                    ),

                    // QR Code (diposisikan lebih akurat dan sedikit lebih besar, tidak menutupi teks)
                    Positioned(
                      top: 30, // Disesuaikan posisi QR code
                      right: 20, // Disesuaikan posisi QR code
                      child: Container(
                        width: 100, // Ukuran QR code
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            MembershipCardPage._qrCodePlaceholder, // Akses dengan nama kelas
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.qr_code, size: 50, color: Colors.black),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Teks "MASTER GYM"
                    Positioned(
                      top: 20,
                      left: 20,
                      // Batasi lebar teks agar tidak menutupi QR code
                      right: 160, // Memberi ruang lebih dari kanan untuk QR code
                      child: const Text(
                        'MASTER GYM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    // Teks "KARTU MEMBER"
                    Positioned(
                      top: 45,
                      left: 20,
                      // Batasi lebar teks agar tidak menutupi QR code
                      right: 160, // Memberi ruang lebih dari kanan untuk QR code
                      child: const Text(
                        'KARTU MEMBER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Tiga titik di bawah "KARTU MEMBER"
                    Positioned(
                      top: 80, 
                      left: 20,
                      child: Row(
                        children: [
                          Container(width: 5, height: 5, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                          const SizedBox(width: 5),
                          Container(width: 5, height: 5, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                          const SizedBox(width: 5),
                          Container(width: 5, height: 5, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                        ],
                      ),
                    ),

                    // Bentuk segitiga/diagonal merah di bawah tulisan Kartu Member (lebih presisi)
                    Positioned(
                      top: 100, // Sesuaikan posisi vertikal
                      left: 0,
                      child: CustomPaint(
                        size: const Size(200, 60), // Ukuran disesuaikan
                        painter: _RedShapePainter(),
                      ),
                    ),

                    // Konten bawah kartu - Informasi Nama & Tanggal Berakhir
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0), // Padding disesuaikan
                        height: 100, // Tinggi bagian bawah disesuaikan untuk info nama
                        decoration: const BoxDecoration(
                          color: Color(0xFF262626), // Abu-abu gelap untuk dasar kartu
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start, // Konten dimulai dari atas
                          children: [
                            Row(
                              children: const [ // Hardcode values for now
                                Text(
                                  'NAMA LENGKAP : ',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'JHON DOE', // Hardcoded full name
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: const [ // Hardcode values for now
                                Text(
                                  'BERAKHIR       : ', // Adjusted spacing for alignment
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '1-AGUSTUS-2024', // Hardcoded expiry date
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(), // Dorong konten ke atas
                            // Garis-garis diagonal di kanan bawah (hanya dekoratif)
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '///////', // Dikurangi garisnya agar pas
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.1),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30), // Jarak antara kartu dan tombol

            // Tombol "Download pdf"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Logic to download PDF (needs implementation)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Download PDF diklik! (Logika belum diimplementasikan)')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Warna merah
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Sudut membulat
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Download pdf',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Jarak antara tombol dan catatan

            // Catatan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Catatan : Kartu ini diperlukan untuk mengisi daftar kehadiran anggota. Mohon untuk selalu membawa atau menunjukkan kartu ini saat memasuki Gym',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 20), // Padding bawah
          ],
        ),
      ),
      // bottomNavigationBar is removed from here
    );
  }
}

// Custom Painter for the red diagonal shape on the card
class _RedShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE53935) // Bright red
      ..style = PaintingStyle.fill;

    final path = Path();
    // Adjust path to create the shape as in the image
    path.moveTo(0, 0); // Start from top left
    path.lineTo(size.width, 0); // To top right
    path.lineTo(size.width - 50, size.height); // Shift left from bottom right
    path.lineTo(0, size.height); // To bottom left
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
