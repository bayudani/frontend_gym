import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/views/auth/splash_screen.dart'; // Import OnboardingScreen
import '../../controllers/profile_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Menambahkan const constructor

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileController()), // Menyediakan ProfileController
      ],
      child: MaterialApp(
        title: 'Gym App',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const OnboardingScreen(), // Aplikasi dimulai dari OnboardingScreen
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}