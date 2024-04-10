import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreExample extends StatefulWidget {
  @override
  _FirestoreExampleState createState() => _FirestoreExampleState();
}

class _FirestoreExampleState extends State<FirestoreExample> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _controller = TextEditingController();
  String _documentContent = '';

  void _createDocument() async {
    try {
      await _firestore.collection('test_collection').doc('test_doc').set({
        'content': _controller.text,
      });
      setState(() {
        _documentContent = _controller.text;
      });
    } catch (e) {
      print('Error creating document: $e');
    }
  }

  void _readDocument() async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('test_collection').doc('test_doc').get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _documentContent = data['content'];
        });
      } else {
        setState(() {
          _documentContent = 'Document does not exist';
        });
      }
    } catch (e) {
      print('Error reading document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Example'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter content',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _createDocument,
              child: Text('Create Document'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _readDocument,
              child: Text('Read Document'),
            ),
            SizedBox(height: 20.0),
            Text(
              _documentContent,
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
