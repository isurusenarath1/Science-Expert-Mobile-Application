import 'package:flutter/material.dart';
import 'package:science_expert01/screens/components/roundButton.dart';
import 'package:science_expert01/screens/student/view_tutorial_screen.dart';

class Tutorials extends StatefulWidget {
  const Tutorials({super.key});

  @override
  State<Tutorials> createState() => _TutorialsState();
}

class _TutorialsState extends State<Tutorials> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        iconTheme: IconThemeData(
            color: Color.fromRGBO(237, 42, 110, 1)), // Removes the back button
        title: Center(
          child: Row(
            children: [
              Text(
                'Tutorials',
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
              height: 40,
            ),
            RoundButton(
              text: 'Biology',
              width: 300,
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewTutorialScreen(subject: 'Biology')),
                );
              },
            ),
            const SizedBox(
              height: 40,
            ),
            RoundButton(
              text: 'Mathematics',
              width: 300,
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewTutorialScreen(subject: 'Mathematics')),
                );
              },
            ),
            const SizedBox(
              height: 40,
            ),
            RoundButton(
              text: 'Physics',
              width: 300,
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewTutorialScreen(subject: 'Physics')),
                );
              },
            ),
            const SizedBox(
              height: 40,
            ),
            RoundButton(
              text: 'Chemistry',
              width: 300,
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewTutorialScreen(subject: 'Chemistry')),
                );
              },
            ),
            const SizedBox(
              height: 40,
            ),
            RoundButton(
              text: 'Agricultural',
              width: 300,
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewTutorialScreen(subject: 'Agricultural')),
                );
              },
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
