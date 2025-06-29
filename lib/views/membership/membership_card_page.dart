import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gym_app/controllers/profile_controller.dart';
import 'package:gym_app/helpers/formatters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart'; // <-- Import yang benar
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class MembershipCardPage extends StatefulWidget {
  const MembershipCardPage({super.key});

  @override
  State<MembershipCardPage> createState() => _MembershipCardPageState();
}

class _MembershipCardPageState extends State<MembershipCardPage> {
  final _screenshotController = ScreenshotController();
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileController>().fetchMemberData(context);
    });
  }

  // --- FUNGSI DOWNLOAD LENGKAP ---
  Future<void> _downloadAndShareCard() async {
    setState(() => _isDownloading = true);
    try {
      final Uint8List? imageBytes = await _screenshotController.capture(
        delay: const Duration(milliseconds: 100),
      );

      if (imageBytes == null) {
        throw Exception("Gagal mengambil gambar kartu.");
      }

      final pdf = pw.Document();
      final image = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a6,
          build: (pw.Context context) => pw.Center(child: pw.Image(image)),
        ),
      );

      final outputDir = await getTemporaryDirectory();
      final file = File("${outputDir.path}/kartu-member-${DateTime.now().millisecondsSinceEpoch}.pdf");
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Ini kartu membership Master Gym saya!',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Oops, gagal download: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
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
        title: const Text('Kartu Membership', style: TextStyle(color: Colors.white)),
      ),
      body: Consumer<ProfileController>(
        builder: (context, controller, child) {
          if (controller.isMemberLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          }
          
          final member = controller.memberData;

          return SingleChildScrollView(
            child: Column(
              children: [
                Screenshot(
                  controller: _screenshotController,
                  child: Padding(
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
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // --- Latar Belakang & Dekorasi Statis (Selalu Tampil) ---
                          Positioned(
                            top: 0, left: 0, right: 0,
                            child: Container(
                              height: 170,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE53935),
                                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0, right: 0,
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
                          const Positioned(
                            top: 20, left: 20, right: 160,
                            child: Text('FITID', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                          ),
                          const Positioned(
                            top: 45, left: 20, right: 160,
                            child: Text('KARTU MEMBER', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          ),
                          Positioned(
                            top: 100, left: 0,
                            child: CustomPaint(size: const Size(200, 60), painter: _RedShapePainter()),
                          ),

                          // === LOGIKA CERDAS: TAMPILKAN KONTEN SESUAI STATUS MEMBER ===
                          if (member != null) ...[
                            // --- KONTEN JIKA SUDAH JADI MEMBER ---
                            _buildMemberContent(member)
                          ] else ...[
                            // --- KONTEN JIKA BELUM JADI MEMBER ---
                            _buildNonMemberContent(),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: member == null ? null : _downloadAndShareCard,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        disabledBackgroundColor: Colors.red.withOpacity(0.4),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: _isDownloading
                          ? const SizedBox(
                              height: 24, width: 24,
                              child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                            )
                          : const Text(
                              'Download & Share',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14,),
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

  // --- WIDGET HELPER UNTUK KONTEN MEMBER ---
  Widget _buildMemberContent(dynamic member) {
    return Stack(
      children: [
        Positioned(
          top: 20, right: 10,
          child: Container(
            width: 120, height: 120,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: QrImageView(data: member.id, version: QrVersions.auto, size: 110.0),
          ),
        ),
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Text('NAMA LENGKAP : ', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                    Expanded(child: Text(member.fullName.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(height: 5),
                 Row(
                  children: [
                    const Text(
    'Habis pada : ',
    style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
  ),
  Expanded(
    child: Text(
      // Ini perubahannya, bro!
      formatTanggal(member.end_date), 
      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      overflow: TextOverflow.ellipsis,
    ),
  ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- WIDGET HELPER UNTUK KONTEN NON-MEMBER ---
  Widget _buildNonMemberContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.credit_card_off_rounded, color: Colors.white.withOpacity(0.8), size: 50),
            const SizedBox(height: 15),
            Text(
              'Anda Belum Terdaftar',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'Silakan daftar sebagai member untuk mendapatkan kartu virtual.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter (tidak berubah)
class _RedShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE53935)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - 50, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}