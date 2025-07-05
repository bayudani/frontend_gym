import 'package:flutter/material.dart';
import 'package:gym_app/controllers/auth_controller.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/views/auth/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart'; // <-- IMPORT INI


import '../../controllers/profile_controller.dart';
import '../../controllers/program_controller.dart';
import '../../controllers/article_controller.dart';
import '../../controllers/attends_controller.dart';
import '../../controllers/comment_controller.dart';
import '../../controllers/membership_controller.dart';
import 'package:gym_app/controllers/ai_controller.dart'; // <-- IMPORT
import 'package:gym_app/controllers/ai_form_checker_controller.dart'; // <-- IMPORT
import 'package:gym_app/controllers/membership_checkout_controller.dart'; // <-- IMPORT CONTROLLER BARU
import 'package:gym_app/controllers/item_rewards_controller.dart'; // <-- IMPORT CONTROLLER BARU
import 'package:gym_app/controllers/reward_history_controller.dart'; // <-- IMPORT CONTROLLER BARU





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
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => AttendanceController()),
        ChangeNotifierProvider(create: (_) => CommentController()), // <-- TAMBAHKAN INI
        ChangeNotifierProvider(create: (_) => MembershipController()), // <-- TAMBAHKAN INI
        ChangeNotifierProvider(create: (_) => AiController()), // <-- TAMBAHKAN INI
        ChangeNotifierProvider(create: (_) => AiFormCheckerController()), // <-- TAMBAHKAN INI
        ChangeNotifierProvider(create: (_) => MembershipCheckoutController()), // <-- TAMBAHKAN INI
        ChangeNotifierProvider(create: (_) => RewardController()), // <-- TAMBAHKAN INI
        ChangeNotifierProvider(create: (_) => RewardHistoryController()),



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