import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:science_expert01/screens/components/roundButton.dart';
import 'package:science_expert01/screens/login_screen.dart';
import 'package:science_expert01/screens/student/main_student_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  void _checkAuthentication() async {
    User? user = _auth.currentUser;
    if (user != null) {
      _navigateToHomePage();
    }
  }

void _navigateToHomePage() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      MainScreen.selectedIndex = 0;
      Navigator.pushReplacementNamed(context, '/main');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // Removes the back button
        elevation: 4,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Color.fromRGBO(237, 42, 110, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(child: Image.asset("assets/learn.png")),
            SizedBox(height: 90),
            Text(
              'Empower your learning journey with our mobile app! Access interactive lessons, quizzes, and progress tracking. Personalized study plans tailored to your needs. Learn anytime, anywhere, at your own pace',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0, // Adjust font size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 90),
            RoundButton(
              text: 'GET START',
              width: 200,
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
