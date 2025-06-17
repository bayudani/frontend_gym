import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart'; // <-- IMPORT QR
import 'package:gym_app/controllers/profile_controller.dart'; // <-- IMPORT CONTROLLER

class MembershipCardPage extends StatefulWidget {
  const MembershipCardPage({super.key});

  @override
  State<MembershipCardPage> createState() => _MembershipCardPageState();
}

class _MembershipCardPageState extends State<MembershipCardPage> {
  @override
  void initState() {
    super.initState();
    // Panggil data member saat halaman pertama kali dibuka
    // Diberi delay singkat agar context siap
    Future.microtask(
      () =>
          Provider.of<ProfileController>(
            context,
            listen: false,
          ).fetchMemberData(),
    );
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
          'Kartu Membership',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<ProfileController>(
        // <-- GUNAKAN CONSUMER
        builder: (context, controller, child) {
          // Tampilkan loading indicator
          if (controller.isMemberLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }

          // Tampilkan jika tidak ada data
          if (controller.memberData == null) {
            return const Center(
              child: Text(
                'Gagal memuat data member.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final member = controller.memberData!;

          // Jika data ada, tampilkan seluruh halaman
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: const Color(0xFF262626),
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
                        // ... (Bagian dekorasi merah, abu-abu, dan titik-titik tetap sama)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 170,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE53935),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 140,
                            height: 100,
                            decoration: const BoxDecoration(
                              color: Color(0xFF262626),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(70),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 15,
                          right: 15,
                          child: Row(
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // --- QR Code Dinamis ---
                        Positioned(
                          top:
                              30, // Agak diturunin dikit biar nggak terlalu mepet atas
                          right: 10, // Agak majuan dikit dari kanan
                          child: Container(
                            width: 120, // Digeedein jadi 120
                            height: 120, // Digeedein jadi 120
                            padding: const EdgeInsets.all(
                              10,
                            ), // Paddingnya disesuaikan dikit
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                10,
                              ), // Radiusnya juga disesuaikan
                            ),
                            child: QrImageView(
                              data: member.id,
                              version: QrVersions.auto,
                              size:
                                  110.0, // Size di dalam QrImageView juga digedein
                            ),
                          ),
                        ),

                        // ... (Teks MASTER GYM, KARTU MEMBER, dan bentuk lainnya tetap sama)
                        const Positioned(
                          top: 20,
                          left: 20,
                          right: 160,
                          child: Text(
                            'MASTER GYM',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        const Positioned(
                          top: 45,
                          left: 20,
                          right: 160,
                          child: Text(
                            'KARTU MEMBER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 80,
                          left: 20,
                          child: Row(
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 100,
                          left: 0,
                          child: CustomPaint(
                            size: const Size(200, 60),
                            painter: _RedShapePainter(),
                          ),
                        ),

                        // --- Informasi Nama & Tanggal Berakhir Dinamis ---
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(
                              20.0,
                              10.0,
                              20.0,
                              20.0,
                            ),
                            height: 100,
                            decoration: const BoxDecoration(
                              color: Color(0xFF262626),
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'NAMA LENGKAP : ',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // -- NAMA DINAMIS --
                                    Text(
                                      member.fullName.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                const Row(
                                  children: [
                                    Text(
                                      'BERAKHIR       : ',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // -- TANGGAL MASIH HARDCODE --
                                    // TODO: Ganti dengan data tanggal berakhir dari API jika sudah tersedia
                                    Text(
                                      '1-AGUSTUS-2024',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    '///////',
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
                // ... (Tombol Download dan Catatan tetap sama)
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Download PDF diklik! (Logika belum diimplementasikan)',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Download pdf',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Custom Painter (tidak berubah)
class _RedShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFFE53935)
          ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - 50, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
