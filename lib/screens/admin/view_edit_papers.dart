import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ViewEditPapers extends StatelessWidget {
  const ViewEditPapers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        iconTheme: IconThemeData(color: Color.fromRGBO(237, 42, 110, 1)),
        title: Center(
          child: Row(
            children: [
              Text(
                'View Papers',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('papers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data?.docs ?? [];
          docs.sort((a, b) =>
              (b['date'] as Timestamp).compareTo(a['date'] as Timestamp));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final pdfUrl = doc['pdfUrl'];
              final subject = doc['subject'];
              final title = doc['title'];
              final timestamp = doc['date'] as Timestamp;

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Subject: $subject'),
                      Text('Date: ${timestamp.toDate()}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _viewPDF(context, pdfUrl);
                        },
                        child: Text('View PDF'),
                      ),
                      SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          _deletePaper(doc.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Delete',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _viewPDF(BuildContext context, String pdfUrl) async {
    final url = Uri.parse(pdfUrl);
    final response = await http.get(url);
    final bytes = response.bodyBytes;

    final tempDir = await getTemporaryDirectory();
    final tempFilePath = '${tempDir.path}/temp.pdf';
    final file = File(tempFilePath);
    await file.writeAsBytes(bytes);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(pdfPath: tempFilePath),
      ),
    );
  }

  Future<void> _deletePaper(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('papers')
          .doc(documentId)
          .delete();
    } catch (e) {
      print('Error deleting paper: $e');
    }
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String pdfPath;

  const PDFViewerScreen({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        iconTheme: IconThemeData(color: Color.fromRGBO(237, 42, 110, 1)),
        title: Center(
          child: Row(
            children: [
              Text(
                'View PDF',
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
      body: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: true,
      ),
    );
  }
}
