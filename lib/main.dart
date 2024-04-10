import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:science_expert01/screens/admin/home_screen.dart';
import 'package:science_expert01/screens/admin/main_admin_screen.dart';
import 'package:science_expert01/screens/forgetpassword_screen.dart';
import 'package:science_expert01/screens/login_screen.dart';
import 'package:science_expert01/screens/signup_screen.dart';
import 'package:science_expert01/screens/student/main_student_screen.dart';
import 'package:science_expert01/screens/welcome_screen.dart';

//main

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.removeAfter(initialization);
  await Firebase.initializeApp();
  runApp(MobileApp());
}

Future initialization(BuildContext? context) async {
  await Future.delayed(Duration(seconds: 2));
}

class MobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MaterialColor customColor = MaterialColor(
      0xFFED2A6E,
      <int, Color>{
        50: Color.fromRGBO(237, 42, 110, 0.1),
        100: Color.fromRGBO(237, 42, 110, 0.2),
        200: Color.fromRGBO(237, 42, 110, 0.3),
        300: Color.fromRGBO(237, 42, 110, 0.4),
        400: Color.fromRGBO(237, 42, 110, 0.5),
        500: Color.fromRGBO(237, 42, 110, 0.6),
        600: Color.fromRGBO(237, 42, 110, 0.7),
        700: Color.fromRGBO(237, 42, 110, 0.8),
        800: Color.fromRGBO(237, 42, 110, 0.9),
        900: Color.fromRGBO(237, 42, 110, 1),
      },
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Science Expert',
      theme: ThemeData(
        primarySwatch: customColor,
      ),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      routes: {
        '/signup': (context) => SignUpScreen(),
        '/login' :(context) => LoginScreen(),
        '/main' : (context) => MainScreen(),
        '/admin': (context) => AdminHomeScreen(),
        '/adminMain': (context) => AdminMainScreen(),
        '/forgetpassword': (context) => ForgotPasswordScreen(),
      },
      home: WelcomeScreen(),
    );
  }
}