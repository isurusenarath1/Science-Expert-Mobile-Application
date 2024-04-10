import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:science_expert01/screens/components/video_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ViewTutorialScreen extends StatelessWidget {
  final String subject;

  const ViewTutorialScreen({Key? key, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(237, 42, 110, 1),
        ), // Removes the back button
        title: Center(
          child: Row(
            children: [
              Text(
                'View Tutorials - $subject', // Display the subject in the app bar
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
        stream: FirebaseFirestore.instance
            .collection('tutorials')
            .where('subject', isEqualTo: subject) // Filter by subject
            .snapshots(),
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

          if (docs.isEmpty) {
            return Center(
              child: Text('No files found.'),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final youtubeLink = doc['youtubeLink'];
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
                          Text('Date: ${timestamp.toDate()}'),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VideoScreen(youtubeLink: youtubeLink),
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(
                            'https://img.youtube.com/vi/$videoId/0.jpg', // Thumbnail URL
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          ),
                          Icon(
                            Icons.play_circle_fill,
                            size: 64,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VideoScreen(youtubeLink: youtubeLink),
                            ),
                          );
                        },
                        child: Text('Watch Video'),
                      ),
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
}
