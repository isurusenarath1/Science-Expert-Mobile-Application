import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

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
                'Messages',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('contacts').snapshots(),
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

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final imageUrl = doc['attachmentUrl'];
              final message = doc['message'];
              final timestamp = doc['timestamp'] as Timestamp;
              final user = doc['user'];

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    message,
                    style: TextStyle(
                        fontWeight: FontWeight.bold), // Bold message text
                  ),
                  subtitle:
                      Text('User: $user\nTimestamp: ${timestamp.toDate()}'),
                  trailing: Visibility(
                    visible: imageUrl != null && imageUrl.isNotEmpty,
                    child: ElevatedButton(
                      onPressed: imageUrl != null && imageUrl.isNotEmpty
                          ? () {
                              _showImageDialog(context, imageUrl);
                            }
                          : null,
                      child: Text('View Image'),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
