import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:science_expert01/screens/components/video_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ViewEditVideos extends StatelessWidget {
  const ViewEditVideos({Key? key}) : super(key: key);

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
                'View Tutorial',
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
        stream: FirebaseFirestore.instance.collection('tutorials').snapshots(),
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

          // Sort documents by date in descending order
          docs.sort((a, b) =>
              (b['date'] as Timestamp).compareTo(a['date'] as Timestamp));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final docId = doc.id; // Document ID for deletion
              final youtubeLink = doc['youtubeLink'];
              final subject = doc['subject'];
              final title = doc['title'];
              final timestamp = doc['date'] as Timestamp;

              // Extracting video ID from YouTube link
              final videoId = YoutubePlayer.convertUrlToId(youtubeLink)!;

              return Card(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Subject: $subject'),
                          Text('Date: ${timestamp.toDate()}'),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Image.network(
                        'https://img.youtube.com/vi/$videoId/0.jpg', // Thumbnail URL
                        fit: BoxFit.cover,
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VideoScreen(youtubeLink: youtubeLink),
                                fullscreenDialog: true,
                              ),
                            );
                          },
                          child: Text('View Video'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _deleteVideo(docId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _deleteVideo(String docId) async {
    await FirebaseFirestore.instance
        .collection('tutorials')
        .doc(docId)
        .delete();
    // You can add a snackbar or dialog to confirm deletion
  }
}