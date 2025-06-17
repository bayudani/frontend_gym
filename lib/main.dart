import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/views/auth/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart'; // <-- IMPORT INI


import '../../controllers/profile_controller.dart';
import '../../controllers/program_controller.dart';
import '../../controllers/article_controller.dart';

void main() async { // <-- Ubah jadi async
  // Pastikan semua binding siap sebelum runApp
  WidgetsFlutterBinding.ensureInitialized(); 

  // Inisialisasi data locale untuk 'id_ID' (Indonesia)
  await initializeDateFormatting('id_ID', null); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Menambahkan const constructor

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileController()), // Menyediakan ProfileController
        ChangeNotifierProvider(create: (context) => ProgramController()), 
        ChangeNotifierProvider(create: (context) => ArticleController()), // <-- TAMBAHKAN INI


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