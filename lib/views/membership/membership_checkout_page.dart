// lib/views/membership/membership_checkout_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/controllers/membership_checkout_controller.dart';
import 'package:gym_app/models/membership_models.dart';
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';
import 'package:gym_app/views/membership/checkout_payment_section.dart';
import 'package:gym_app/views/membership/checkout_biodata_section.dart';
import 'package:gym_app/views/home/home_page.dart'; // Import untuk navigasi sukses

class MembershipCheckoutPage extends StatefulWidget {
  final String membershipId;

  const MembershipCheckoutPage({
    super.key,
    required this.membershipId,
  });

  @override
  State<MembershipCheckoutPage> createState() => _MembershipCheckoutPageState();
}

class _MembershipCheckoutPageState extends State<MembershipCheckoutPage> {
  int _selectedIndex = 2;
  // KUNCI GLOBAL untuk mengakses state dari CheckoutBiodataSection
  final GlobalKey<CheckoutBiodataSectionState> _biodataKey = GlobalKey<CheckoutBiodataSectionState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MembershipCheckoutController>(context, listen: false)
          .fetchMembershipDetails(widget.membershipId);
    });
  }

  // --- FUNGSI UNTUK MENANGANI TOMBOL KIRIM ---
  void _handleSubmit() async {
    // 1. Akses state dari biodata section via GlobalKey
    final biodataState = _biodataKey.currentState;
    final controller = Provider.of<MembershipCheckoutController>(context, listen: false);

    // Validasi dasar, pastikan state tidak null
    if (biodataState == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Gagal mengakses form biodata.')),
      );
      return;
    }

    // 2. Panggil fungsi submit dari controller, kirim semua data dari form
    final success = await controller.submitTransaction(
      fullName: biodataState.nameController.text,
      address: biodataState.addressController.text,
      phone: biodataState.phoneController.text,
      proofImage: biodataState.pickedImage,
    );

    // 3. Handle hasil dari controller
    if (mounted) { // Pastikan widget masih ada di tree sebelum update UI
      if (success) {
        // Tampilkan dialog sukses lalu navigasi ke home
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
            backgroundColor: const Color(0xFF262626),
            title: const Text('Transaksi Berhasil', style: TextStyle(color: Colors.white)),
            content: const Text(
              'Transaksi kamu sedang diproses. Cek email untuk info selanjutnya.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                  // Ganti semua halaman sampai root dan buka HomePage
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        );
      } else {
        // Tampilkan pesan error dari controller jika gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.submissionError ?? 'Terjadi kesalahan tidak diketahui.'),
            backgroundColor: Colors.redAccent,
          ),
        );
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
        title: const Text('Checkout', style: TextStyle(color: Colors.white)),
      ),
      body: Consumer<MembershipCheckoutController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if (controller.errorMessage != null) {
            return Center(child: Text(controller.errorMessage!, style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center));
          }
          if (controller.selectedPlan == null) {
            return const Center(child: Text("Detail membership tidak ditemukan.", style: TextStyle(color: Colors.white70)));
          }
          
          final plan = controller.selectedPlan!;
          // Kirim controller ke build body untuk akses state 'isSubmitting'
          return _buildCheckoutBody(context, plan, controller);
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // --- UBAH BODY UNTUK MENGHUBUNGKAN SEMUANYA ---
  Widget _buildCheckoutBody(BuildContext context, MembershipPlan plan, MembershipCheckoutController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Ringkasan produk'),
          const SizedBox(height: 10),
          _buildProductSummaryCard(context, plan),
          const SizedBox(height: 20),
          const CheckoutPaymentSection(),
          const SizedBox(height: 20),
          // Berikan key ke CheckoutBiodataSection agar statenya bisa diakses
          CheckoutBiodataSection(key: _biodataKey),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // Saat ditekan, panggil _handleSubmit
              // Nonaktifkan tombol saat sedang submitting
              onPressed: controller.isSubmitting ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              // Tampilkan loading indicator atau teks "Kirim"
              child: controller.isSubmitting
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : const Text('Kirim', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget _buildProductSummaryCard dan _buildSectionHeader tetap sama
  // Tidak perlu diubah dari versi sebelumnya.
  Widget _buildProductSummaryCard(BuildContext context, MembershipPlan plan) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plan.name,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              Text(
                plan.formattedPrice,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal',
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
              Text(
                plan.formattedPrice,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle)),
              const SizedBox(width: 5),
              Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle)),
            ],
          ),
        ],
      ),
    );
  }
}
