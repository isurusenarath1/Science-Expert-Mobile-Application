import 'package:flutter/material.dart';
import 'package:science_expert01/screens/components/roundButton.dart';
import 'package:science_expert01/screens/student/papers_screen.dart';
import 'package:science_expert01/screens/student/tutorial_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                'Science Stream',
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
            const SizedBox(
              height: 20,
            ),
            Center(child: Image.asset("assets/grade.png")),
            const SizedBox(
              height: 90,
            ),
            RoundButton(
              text: 'Papers',
              width: 200,
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Papers()),
                );
              },
            ),
            const SizedBox(
              height: 40,
            ),
            RoundButton(
              text: 'Tutorials',
              width: 200,
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Tutorials()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
