import 'package:flutter/material.dart';
import 'package:gym_app/controllers/auth_controller.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/views/auth/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';


import '../../controllers/profile_controller.dart';
import '../../controllers/program_controller.dart';
import '../../controllers/article_controller.dart';
import '../../controllers/attends_controller.dart';
import '../../controllers/comment_controller.dart';
import '../../controllers/membership_controller.dart';
import 'package:gym_app/controllers/ai_controller.dart';
import 'package:gym_app/controllers/ai_form_checker_controller.dart';
import 'package:gym_app/controllers/membership_checkout_controller.dart';
import 'package:gym_app/controllers/item_rewards_controller.dart';
import 'package:gym_app/controllers/reward_history_controller.dart';





void main() async {

  WidgetsFlutterBinding.ensureInitialized(); 

  await initializeDateFormatting('id_ID', null); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (context) => ProgramController()), 
        ChangeNotifierProvider(create: (context) => ArticleController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => AttendanceController()),
        ChangeNotifierProvider(create: (_) => CommentController()),
        ChangeNotifierProvider(create: (_) => MembershipController()),
        ChangeNotifierProvider(create: (_) => AiController()),
        ChangeNotifierProvider(create: (_) => AiFormCheckerController()),
        ChangeNotifierProvider(create: (_) => MembershipCheckoutController()),
        ChangeNotifierProvider(create: (_) => RewardController()),
        ChangeNotifierProvider(create: (_) => RewardHistoryController()),



      ],
      child: MaterialApp(
        title: 'Gym App',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const OnboardingScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}