import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lorsoth111/app_colors.dart';
import 'package:lorsoth111/login_user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyHomeApp());
}

class MyHomeApp extends StatelessWidget {
  const MyHomeApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BTB111 App',
      home: const LoginUser(), // where to go, startup screen, launcher screen
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.bgColor,
          titleTextStyle: TextStyle(color: AppColors.textColor, fontSize: 18),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          iconTheme: IconThemeData(color: AppColors.textColor),
        ),
      ),
    );
  }
}

// Widget: (UI Components)
// 1. Stateless Widget (Method)
// 2. Stateful Widget (Class)

// Meterial Design (Andriod)
// Cupertino Design (IOS)
