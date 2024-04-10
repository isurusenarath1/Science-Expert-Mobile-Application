import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path_context;
import 'package:science_expert01/screens/admin/view_edit_papers.dart';
import 'package:science_expert01/screens/components/squareButton.dart';

class AddPapersScreen extends StatefulWidget {
  const AddPapersScreen({Key? key}) : super(key: key);

  @override
  State<AddPapersScreen> createState() => _AddPapersScreenState();
}

class _AddPapersScreenState extends State<AddPapersScreen> {
  String? _selectedSubject;
  TextEditingController _titleController = TextEditingController();
  String? _pdfUrl;
  String? _attachedPdfFilename;

  Future<void> _attachPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(path_context.context.join(result.files.single.path!));
      final fileName = path_context.basename(file.path);
      final destination = 'papers/$fileName';
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(destination);
      await ref.putFile(file);
      final pdfUrl = await ref.getDownloadURL();
      setState(() {
        _pdfUrl = pdfUrl;
        _attachedPdfFilename = fileName;
      });
    }
  }

  Future<void> _addPaper() async {
    if (_selectedSubject == null ||
        _titleController.text.isEmpty ||
        _pdfUrl == null) {
      // Show error dialog if any required field is missing
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill all fields and attach a PDF file.'),
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
      // Add paper details to Firestore
      await FirebaseFirestore.instance.collection('papers').add({
        'subject': _selectedSubject,
        'title': _titleController.text,
        'pdfUrl': _pdfUrl,
        'date': DateTime.now(),
      });

      // Reset fields after adding paper
      setState(() {
        _selectedSubject = null;
        _titleController.clear();
        _pdfUrl = null;
        _attachedPdfFilename = null;
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Paper added successfully.'),
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
                'Add Papers',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Image.asset(
                  "assets/addfiles.png",
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
                  'Agricultural'
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
              ElevatedButton(
                onPressed: _attachPdf,
                child: Text('Attach PDF'),
              ),
              SizedBox(height: 16.0),
              Text(
                _attachedPdfFilename ?? 'No PDF attached',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addPaper,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromRGBO(237, 42, 110, 1), // Background color
                ),
                child: Text(
                  'Add Paper',
                  style: TextStyle(
                    color: Colors.white, // Text color
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              SquareButton(
                text: 'View All Papers',
                size: 80,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewEditPapers()),
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