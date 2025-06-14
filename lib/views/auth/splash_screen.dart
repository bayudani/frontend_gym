import 'package:flutter/material.dart';
import 'package:gym_app/views/auth/login_page.dart'; // Import halaman login_page

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background Scaffold transparan untuk menampilkan Stack
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/1.png',
                ), // Pastikan gambar ini ada
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(
                    0.4,
                  ), // Sedikit lebih transparan di atas
                  Colors.black.withOpacity(0.8), // Lebih gelap di bawah
                ],
              ),
            ),
          ),
          // Konten Utama
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Konten di bagian bawah
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Teks rata tengah
                children: [
                  // Text "Bangun Badan Impian Mu Di Brother Gym"
                  RichText(
                    textAlign: TextAlign.center, // Menyamakan rata teks
                    text: TextSpan(
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 32, // Ukuran font disesuaikan
                      ),
                      children: const [
                        TextSpan(text: "Bangun Badan Impian\nMu Dengan "),
                        TextSpan(
                          text: "Fit.Id",
                          style: TextStyle(
                            color:
                                Colors.red, // Warna merah untuk "Brother Gym"
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Text "Lorem ipsum dolor sit amet consectetur."
                  const Text(
                    "Lorem ipsum dolor sit amet\nconsectetur.", // Teks deskripsi
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center, // Ubah menjadi rata tengah
                  ),
                  const SizedBox(height: 40), // Jarak sebelum tombol
                  // Tombol "Get started"
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ), // Navigasi ke halaman login
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Warna merah
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // Sudut membulat
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Get started",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Text "Already have account? Log in"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have account? ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ), // Navigasi ke halaman login
                          );
                        },
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                            color: Colors.white, // Warna putih untuk "Log in"
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40), // Padding bawah
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
