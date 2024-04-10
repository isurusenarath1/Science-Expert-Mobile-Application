import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ViewPapersScreen extends StatelessWidget {
  final String subject;

  const ViewPapersScreen({Key? key, required this.subject}) : super(key: key);

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
                '${subject} Papers',
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

          // Filter papers by subject (for example, Biology)
          final filteredDocs =
              docs.where((doc) => doc['subject'] == subject).toList();

          // Sort papers by date in descending order
          filteredDocs.sort((a, b) =>
              (b['date'] as Timestamp).compareTo(a['date'] as Timestamp));

          if (filteredDocs.isEmpty) {
            return Center(
              child: Text('No records found.'),
            );
          }

          return ListView.builder(
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              final doc = filteredDocs[index];
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
                  trailing: ElevatedButton(
                    onPressed: () {
                      _viewPDF(context, pdfUrl, title);
                    },
                    child: Text('View PDF'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _viewPDF(
      BuildContext context, String pdfUrl, String title) async {
    final url = Uri.parse(pdfUrl);
    final response = await http.get(url);
    final bytes = response.bodyBytes;

    final tempDir = await getTemporaryDirectory();
    final tempFilePath =
        '${tempDir.path}/$title.pdf'; // Use title for unique file name
    final file = File(tempFilePath);
    await file.writeAsBytes(bytes);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(pdfPath: tempFilePath),
      ),
    );
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
