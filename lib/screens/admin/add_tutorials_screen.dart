import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:science_expert01/screens/admin/view_edit_videos.dart';
import 'package:science_expert01/screens/components/squareButton.dart';

class AddTutorialsScreen extends StatefulWidget {
  const AddTutorialsScreen({Key? key}) : super(key: key);

  @override
  State<AddTutorialsScreen> createState() => _AddTutorialsScreenState();
}

class _AddTutorialsScreenState extends State<AddTutorialsScreen> {
  String? _selectedSubject;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _youtubeLinkController = TextEditingController();

  Future<void> _addTutorial() async {
    if (_selectedSubject == null ||
        _titleController.text.isEmpty ||
        _youtubeLinkController.text.isEmpty) {
      // Show error dialog if any required field is missing
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill all fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Add tutorial details to Firestore
      await FirebaseFirestore.instance.collection('tutorials').add({
        'subject': _selectedSubject,
        'title': _titleController.text,
        'youtubeLink': _youtubeLinkController.text,
        'date': DateTime.now(),
      });

      // Reset fields after adding tutorial
      setState(() {
        _selectedSubject = null;
        _titleController.clear();
        _youtubeLinkController.clear();
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Tutorial added successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

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
                'Add Tutorial',
                style: TextStyle(
                  fontSize: 25.0,
                  color: Color.fromRGBO(237, 42, 110, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Image.asset(
                  "assets/addVideo.png",
                  width: 200, // Set your desired width
                  height: 200, // Set your desired height
                ),
              ),
              DropdownButtonFormField<String>(
                value: _selectedSubject,
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value;
                  });
                },
                items: [
                  'Biology',
                  'Mathematics',
                  'Physics',
                  'Chemistry',
                  'Agricultural',
                ].map((subject) {
                  return DropdownMenuItem<String>(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _youtubeLinkController,
                decoration: InputDecoration(
                  labelText: 'YouTube Link',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addTutorial,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromRGBO(237, 42, 110, 1), // Background color
                ),
                child: Text(
                  'Add Tutorial',
                  style: TextStyle(
                    color: Colors.white, // Text color
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              SquareButton(
                text: 'View All Tutorials',
                size: 80,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewEditVideos()),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
