import 'package:flutter/material.dart';
import 'package:gym_app/views/home/home_page.dart'; // Import HomePage untuk navigasi
import 'package:gym_app/views/membership/membership_card_page.dart'; // Import MembershipCardPage
import 'package:gym_app/views/profile/profile_page.dart'; // Import ProfilePage
import 'package:gym_app/views/membership/membership.dart'; // Import MembershipPage (halaman utama membership)
import 'package:gym_app/views/blog/blog_page.dart'; // Import BlogPage

// Sebuah widget yang dapat digunakan kembali untuk BottomNavigationBar
class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex; // Index item yang sedang aktif
  final Function(int) onItemTapped; // Callback ketika item diklik

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  // Metode navigasi internal yang memanggil callback dari parent
  void _navigateBasedOnIndex(int index, BuildContext context) {
    // Pastikan widget masih terpasang sebelum melakukan navigasi
    if (!context.mounted) return;

    // Gunakan pushReplacement agar ketika kembali, tidak kembali ke halaman sebelumnya di stack yang sama
    // dan hindari menumpuk halaman yang sama di navigation stack.
    // Gunakan PageRouteBuilder dengan transitionDuration.zero untuk tidak ada animasi transisi.
    if (index == 0) { // Home
      if (ModalRoute.of(context)?.settings.name != '/') {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const HomePage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            settings: const RouteSettings(name: '/'),
          ),
        );
      }
    } else if (index == 1) { // Blog (Sekarang di Index 1)
      if (ModalRoute.of(context)?.settings.name != '/blog') {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const BlogPage(), // Navigasi ke BlogPage
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            settings: const RouteSettings(name: '/blog'),
          ),
        );
      }
    } else if (index == 2) { // Membership (Sekarang di Index 2)
      if (ModalRoute.of(context)?.settings.name != '/membership') {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const MembershipPage(), // Navigasi ke MembershipPage
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            settings: const RouteSettings(name: '/membership'),
          ),
        );
      }
    } else if (index == 3) { // Profile (Sekarang di Index 3)
      if (ModalRoute.of(context)?.settings.name != '/profile') {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const ProfilePage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            settings: const RouteSettings(name: '/profile'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black, // Latar belakang hitam
      type: BottomNavigationBarType.fixed, // Memastikan item tetap terlihat
      selectedItemColor: Colors.red, // Warna ikon dan label yang dipilih
      unselectedItemColor: Colors.grey, // Warna ikon dan label yang tidak dipilih
      currentIndex: widget.selectedIndex, // Menggunakan selectedIndex dari widget
      onTap: (index) {
        widget.onItemTapped(index); // Memanggil callback parent untuk update state
        _navigateBasedOnIndex(index, context); // Melakukan navigasi
      },
      items: const <BottomNavigationBarItem>[
        // Home Item (Index 0)
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        // Blog Item (Index 1) - BLOG SEKARANG DI INDEX 1
        BottomNavigationBarItem(
          icon: Icon(Icons.book), // Icon buku
          label: 'Blog',
        ),
        // Membership Item (Index 2) - MEMBERSHIP SEKARANG DI INDEX 2
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center), // Icon kebugaran
          label: 'Membership',
        ),
        // Profile Item (Index 3) - PROFILE SEKARANG DI INDEX 3
        BottomNavigationBarItem(
          icon: Icon(Icons.person), // Icon orang
          label: 'Profile',
        ),
      ],
    );
  }
}
