import 'package:coffe2/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(

       const CoffeeRecommendationApp(),

  );
}

class CoffeeRecommendationApp extends StatelessWidget {
  const CoffeeRecommendationApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kahve Kaşifi',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: LoginScreen(),
    );
  }
}
