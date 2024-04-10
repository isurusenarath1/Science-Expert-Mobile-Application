import 'package:flutter/material.dart';
import 'package:science_expert01/screens/admin/add_papers_screen.dart';
import 'package:science_expert01/screens/admin/add_tutorials_screen.dart';
import 'package:science_expert01/screens/components/roundButton.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
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
                'Papers and Tutorials',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Color.fromRGBO(237, 42, 110, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: Icon(Icons.logout),
            color: Color.fromRGBO(237, 42, 110, 1),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(child: Image.asset("assets/admin.png")),
            const SizedBox(
              height: 60,
            ),
            RoundButton(
              text: 'Add Papers',
              width: 200,
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPapersScreen()),
                );
              },
            ),
            const SizedBox(
              height: 40,
            ),
            RoundButton(
              text: 'Add Tutorials',
              width: 200,
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTutorialsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
