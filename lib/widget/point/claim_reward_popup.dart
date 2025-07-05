import 'package:flutter/material.dart';

// Gambar untuk pop-up
const _popupGiftBoxImage = 'assets/images/popup_gift_box.png'; // Gambar kotak kado di pop-up
const _popupSupplementImage = 'assets/images/popup_supplement.png'; // Gambar suplemen di pop-up

// Fungsi untuk menampilkan pop-up klaim reward
void showClaimSuccessPopup(BuildContext context, String productName) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) { // Menggunakan dialogContext untuk pop dialog
      return Dialog(
        backgroundColor: Colors.transparent, // Membuat background dialog transparan
        insetPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0), // Padding dari tepi layar
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: const Color(0xFFE53935), // Warna merah solid untuk pop-up
            borderRadius: BorderRadius.circular(15), // Sudut membulat
          ),
          child: Stack( // Menggunakan Stack untuk penempatan elemen-elemen
            alignment: Alignment.topCenter,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min, // Mengambil ruang seminimal mungkin
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 24), // Tombol silang di kanan atas
                      onPressed: () {
                        Navigator.pop(dialogContext); // Tutup pop-up
                      },
                    ),
                  ),
                  const SizedBox(height: 10), // Jarak dari tombol silang
                  const Text(
                    'Selamat Bro!!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Anda dapat reward $productName! Silahkan cek di email anda, dan lakukan konfirmasi ke admin FitID untuk mengklaim hadiah tersebut. Terima kasih telah menjadi member setia kami.',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Gambar kotak hadiah dan suplemen
                  // Menggunakan Stack untuk menempatkan suplemen di atas kotak hadiah
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        _popupGiftBoxImage, // Gambar kotak hadiah
                        height: 120, // Tinggi kotak hadiah
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.card_giftcard, size: 100, color: Colors.white70);
                        },
                      ),
                      Positioned(
                        bottom: 20, // Sesuaikan posisi vertikal suplemen di atas kotak
                        // right: 0, // Hapus right jika ingin di tengah kotak
                        child: Image.asset(
                          _popupSupplementImage, // Gambar suplemen
                          height: 80, // Tinggi suplemen
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox.shrink(); // Kosong jika gambar tidak ada
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
     ] ),
          ),
        );
      },
    );
  }
