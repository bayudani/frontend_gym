import 'package:flutter/material.dart';
import 'package:gym_app/views/home/home_page.dart';
import 'package:gym_app/views/membership/membership_card_page.dart';
import 'package:gym_app/views/profile/profile_page.dart';
import 'package:gym_app/views/membership/membership.dart';
import 'package:gym_app/views/blog/blog_page.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  void _navigateBasedOnIndex(int index, BuildContext context) {
    if (!context.mounted) return;

    if (index == 0) {
      // Home
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
    } else if (index == 1) {
      // Blog (Sekarang di Index 1)
      if (ModalRoute.of(context)?.settings.name != '/blog') {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation1, animation2) =>
                    const BlogPage(), // Navigasi ke BlogPage
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            settings: const RouteSettings(name: '/blog'),
          ),
        );
      }
    } else if (index == 2) {
      // Membership (Sekarang di Index 2)
      if (ModalRoute.of(context)?.settings.name != '/membership') {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation1, animation2) =>
                    const MembershipPage(), // Navigasi ke MembershipPage
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            settings: const RouteSettings(name: '/membership'),
          ),
        );
      }
    } else if (index == 3) {
      // Profile (Sekarang di Index 3)
      if (ModalRoute.of(context)?.settings.name != '/profile') {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation1, animation2) => const ProfilePage(),
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
      backgroundColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      currentIndex: widget.selectedIndex,
      onTap: (index) {
        widget.onItemTapped(index);
        _navigateBasedOnIndex(index, context);
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Blog'),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Membership',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
