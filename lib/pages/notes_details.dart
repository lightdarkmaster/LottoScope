import 'package:flutter/material.dart';

class NoteDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const NoteDetailPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: screenWidth * 0.9, // Set card width to 90% of screen width
              child: Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Ensures the height adjusts dynamically
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        content,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
