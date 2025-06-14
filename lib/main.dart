import 'package:flutter/material.dart';
import 'package:gym_app/views/auth/splash_screen.dart'; // Import OnboardingScreen
// import 'views/auth/login_page.dart'; // Ini sudah tidak perlu di sini jika OnboardingScreen adalah halaman awal
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';
import 'package:gym_app/views/home/home_page.dart';
import 'package:gym_app/views/membership/membership.dart'; // Import MembershipPage
import 'package:gym_app/views/profile/profile_page.dart'; // Import ProfilePage
import 'package:gym_app/views/blog/blog_page.dart'; // Import BlogPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Menambahkan const constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const OnboardingScreen(), // Aplikasi dimulai dari OnboardingScreen
      debugShowCheckedModeBanner: false,
    );
  }
}
