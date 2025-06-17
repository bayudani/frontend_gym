import 'package:flutter/material.dart';
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';
import 'package:gym_app/views/home/home_page.dart'; // Import HomePage for navigation
import 'package:gym_app/views/membership/membership.dart'; // Import MembershipPage for navigation
import 'package:gym_app/views/profile/profile_page.dart'; // Import ProfilePage for navigation
import 'package:gym_app/views/blog/blog_page.dart'; // Import BlogPage for navigation


class PointPage extends StatefulWidget {
  const PointPage({super.key});

  @override
  State<PointPage> createState() => _PointPageState();
}

class _PointPageState extends State<PointPage> {
  // Misalkan indeks untuk halaman Poin adalah 4 jika ditambahkan ke BottomNavBar,
  // atau biarkan 0 jika tidak dikelola oleh BottomNavBar.
  // Untuk contoh ini, kita akan asumsikan ini bukan bagian dari BottomNavBar,
  // jadi selectedIndex akan tetap di Home (0) saat kembali.
  int _selectedIndex = 0; // Atau indeks yang sesuai jika ini adalah tab baru di nav bar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigasi ditangani oleh CustomBottomNavBar secara internal.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Latar belakang hitam
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
          'My Points',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Total Poin Anda:',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '1250 Poin', // Contoh jumlah poin
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Tukarkan poin Anda dengan hadiah menarik!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex, // Ini akan tetap menyorot Home jika tidak ada navigasi aktif
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
