import 'package:flutter/material.dart';

const _popupGiftBoxImage = 'assets/images/popup_gift_box.png';
const _popupSupplementImage = 'assets/images/popup_supplement.png';

void showClaimSuccessPopup(BuildContext context, String productName) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 24.0,
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: const Color(0xFFE53935),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
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
                    'Anda dapat reward $productName! silahkan tunjukkan bukti di email anda dan ambil reward di FItID, dan selamat menikmati. Terima kasih telah menjadi member setia kami.',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Gambar hadiah dan suplemen
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        _popupGiftBoxImage,
                        height: 120,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.card_giftcard,
                            size: 100,
                            color: Colors.white70,
                          );
                        },
                      ),
                      Positioned(
                        bottom: 20,
                        child: Image.asset(
                          _popupSupplementImage,
                          height: 80,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showFinalConfirmationPopup(BuildContext context, String productName) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Berhasil!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Reward "$productName" telah selesai kamu klaim. Selamat menikmati dan tetap semangat nge-gym, bro! 🔥',
                style: const TextStyle(color: Colors.white, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(_popupGiftBoxImage, height: 120),
                  Positioned(
                    bottom: 20,
                    child: Image.asset(_popupSupplementImage, height: 80),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                ),
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('OK, Mantap!'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
