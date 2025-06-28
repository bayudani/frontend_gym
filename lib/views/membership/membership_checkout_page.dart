import 'package:flutter/material.dart';
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';
import 'package:gym_app/views/home/home_page.dart'; // Import HomePage for navigation
import 'package:gym_app/views/profile/profile_page.dart'; // Import ProfilePage for navigation
import 'package:gym_app/views/membership/membership.dart'; // Import MembershipPage

// Import widget-widget bagian yang baru
import 'package:gym_app/views/membership/checkout_payment_section.dart';
import 'package:gym_app/views/membership/checkout_biodata_section.dart';


// Style border input field yang sama dengan halaman login/register
// Dihapus dari sini karena sudah dipindahkan ke masing-masing file section
// const _outlineInputBorder = OutlineInputBorder(
//   borderSide: BorderSide(color: Color(0xFF757575)),
//   borderRadius: BorderRadius.all(Radius.circular(10)),
// );

class MembershipCheckoutPage extends StatefulWidget {
  // Anda bisa menambahkan parameter di sini jika ingin ringkasan produk dinamis
  final String membershipType;
  final String membershipPrice;

  const MembershipCheckoutPage({
    super.key,
    this.membershipType = 'Membership 1 bulan', // Default value
    this.membershipPrice = 'Rp 200.000', // Default value
  });

  @override
  State<MembershipCheckoutPage> createState() => _MembershipCheckoutPageState();
}

class _MembershipCheckoutPageState extends State<MembershipCheckoutPage> {
  // Controllers untuk input biodata
  // Dihapus dari sini karena sudah dipindahkan ke CheckoutBiodataSection
  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _phoneController = TextEditingController();
  // final TextEditingController _addressController = TextEditingController();

  // Untuk mengelola indeks item navigasi bawah yang dipilih
  // PERBAIKAN: Mengatur _selectedIndex ke 2 agar sesuai dengan posisi 'Membership' di CustomBottomNavBar
  int _selectedIndex = 2; // Sesuaikan dengan posisi Membership di CustomBottomNavBar (Home 0, Blog 1, Membership 2, Profile 3)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigasi ditangani oleh CustomBottomNavBar secara internal.
  }

  @override
  void dispose() {
    // Controllers yang dipindahkan ke section terpisah tidak perlu di-dispose di sini
    // _nameController.dispose();
    // _phoneController.dispose();
    // _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Latar belakang utama hitam
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
          'Checkout',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Ringkasan Produk
            _buildSectionHeader(context, 'Ringkasan produk'),
            const SizedBox(height: 10),
            _buildProductSummaryCard(context),
            const SizedBox(height: 20),

            // PERBAIKAN: Memanggil widget CheckoutPaymentSection yang baru
            const CheckoutPaymentSection(),
            const SizedBox(height: 20), // Jarak antara Payment dan Biodata

            // PERBAIKAN: Memanggil widget CheckoutBiodataSection yang baru
            const CheckoutBiodataSection(),
            const SizedBox(height: 30), // Jarak antara Biodata dan tombol Kirim

            // Tombol "Kirim"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Logika untuk mengirim data checkout
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Form Checkout dikirim! (Logika belum diimplementasikan)')),
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
                  'Kirim',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
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

  // Helper Widget untuk Header Bagian (Ringkasan produk)
  // Ini tetap di sini karena Ringkasan Produk ada di file ini
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF262626), // Abu-abu gelap
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[800]!), // Border abu-abu tipis
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
          // Dua titik di kanan (dekoratif)
          Row(
            children: [
              Container(width: 5, height: 5, decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), shape: BoxShape.circle)),
              const SizedBox(width: 5),
              Container(width: 5, height: 5, decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), shape: BoxShape.circle)),
            ],
          ),
        ],
      ),
    );
  }

  // Widget untuk Kartu Ringkasan Produk
  // Ini tetap di sini karena Ringkasan Produk ada di file ini
  Widget _buildProductSummaryCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF262626), // Abu-abu gelap
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[800]!), // Border abu-abu tipis
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.membershipType, // Menggunakan data dari parameter
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.membershipPrice, // Menggunakan data dari parameter
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              Text(
                widget.membershipPrice, // Menggunakan data dari parameter
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
