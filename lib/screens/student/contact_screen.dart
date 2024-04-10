import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late TextEditingController _messageController;
  FirebaseAuth _auth = FirebaseAuth.instance;
  File? _image;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

Future<void> _sendMessage() async {
    // Upload image to Firebase Storage
    String imageUrl = '';
    if (_image != null) {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(
              'attachments/${DateTime.now().millisecondsSinceEpoch}${_image!.path.split('/').last}');
      await ref.putFile(_image!);
      imageUrl = await ref.getDownloadURL();
    }

    // Save message and attachment URL to Firestore
    await FirebaseFirestore.instance.collection('contacts').add({
      'user': _auth.currentUser?.email.toString(),
      'message': _messageController.text,
      'attachmentUrl': imageUrl,
      'timestamp': DateTime.now(),
    });

    // Clear text and image after sending message
    _messageController.clear();
    setState(() {
      _image = null;
    });

    // Show success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Message sent successfully.'),
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

  Future<void> _attachImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 4, // Removes the back button
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Contact Us',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                maxLines: null, // Allow multiline input
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            if (_image != null)
              Image.file(
                _image!,
                width: 150, // Set desired width
                height: 150, // Set desired height
                fit: BoxFit
                    .cover, // Ensure the image covers the specified dimensions
              ) // Show attached image if available
            else
              SizedBox(), // Empty SizedBox if no image attached
            // Empty SizedBox if no image attached
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _attachImage,
                  icon: Icon(Icons.attach_file),
                  label: Text('Attach Image'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: _sendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromRGBO(237, 42, 110, 1), // Background color
                  ),
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.white, // Text color
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
