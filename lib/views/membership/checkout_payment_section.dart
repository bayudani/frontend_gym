import 'package:flutter/material.dart';

// Style border input field yang sama dengan halaman login/register
// Ini diulang di sini karena widget ini mungkin perlu mandiri
const _outlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(10)),
);

class CheckoutPaymentSection extends StatelessWidget {
  const CheckoutPaymentSection({super.key});

  // Helper Widget untuk Header Bagian (diulang dari MembershipCheckoutPage untuk konsistensi)
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

  // Helper Widget untuk Kartu Info Bank
  Widget _buildBankInfoCard(
    BuildContext context, {
    required String bankLogo,
    required String bankName,
    required String accountNumber,
    required String accountName,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.black, // Latar belakang hitam untuk setiap bank card
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[700]!), // Border abu-abu sedikit lebih gelap
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PERBAIKAN: Menyesuaikan ukuran Container logo dan membuat sudut lebih bulat
          Container(
            width: 70, // Lebar total container logo
            height: 70, // Tinggi total container logo
            // padding: const EdgeInsets.all(8.0), // Padding ini DIHAPUS agar logo lebih penuh di dalam kotak
            decoration: BoxDecoration(
              color: Colors.white, // Latar belakang putih untuk logo
              borderRadius: BorderRadius.circular(20), // PERBAIKAN: Sudut membulat lebih besar (dari 15)
            ),
            child: Image.asset(
              bankLogo, // Logo bank
              fit: BoxFit.contain, // Memastikan gambar pas di dalam container tanpa terpotong
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bankName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'No. Rekening: $accountNumber',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'A/N: $accountName',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Payment'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFF262626), // Abu-abu gelap
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[800]!), // Border abu-abu tipis
          ),
          child: Column(
            children: [
              _buildBankInfoCard(
                context,
                bankLogo: 'assets/images/logoBri.png', // Ganti dengan logo BRI Anda
                bankName: 'Bank BRI Indonesia',
                accountNumber: '18203795908643428',
                accountName: 'Bayu Dani Murti',
              ),
              const SizedBox(height: 15),
              _buildBankInfoCard(
                context,
                bankLogo: 'assets/images/logoBca.png', // Ganti dengan logo BCA Anda
                bankName: 'Bank Central Asia',
                accountNumber: '1820814389678537',
                accountName: 'Rama Otari',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
