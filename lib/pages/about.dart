import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.amber,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About the App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'My Lotto is a simple and user-friendly application that helps you manage and track your lottery tickets. '
              'With this app, you can easily check the latest lottery results, save your favorite numbers, and get notifications for upcoming draws.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'About the Developer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'The app was developed by a passionate software developer who loves creating useful and engaging applications. '
              'With a strong background in mobile app development, the developer aims to provide high-quality apps that enhance the user experience.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}