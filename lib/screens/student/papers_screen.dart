import 'package:flutter/material.dart';
import 'package:science_expert01/screens/components/roundButton.dart';
import 'package:science_expert01/screens/student/view_papers_screen.dart';

class Papers extends StatefulWidget {
  const Papers({super.key});

  @override
  State<Papers> createState() => _PapersState();
}

class _PapersState extends State<Papers> {
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
                'Papers',
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
                    builder: (context) => ViewPapersScreen(subject: 'Biology'),
                  ),
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
                    builder: (context) => ViewPapersScreen(subject: 'Mathematics'),
                  ),
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
                        ViewPapersScreen(subject: 'Physics'),
                  ),
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
                    builder: (context) => ViewPapersScreen(subject: 'Chemistry'),
                  ),
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
                        ViewPapersScreen(subject: 'Agricultural'),
                  ),
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
