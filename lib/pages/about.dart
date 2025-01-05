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
      body: SingleChildScrollView(  // Wrap the body content in a SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Justify the contents with space between
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circular Image (using local image)
              const Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/icons/pcsologo.png'), // Local image
                ),
              ),
              const SizedBox(height: 20),
              
              // "About the App" Card
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
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
                        'LottoScope is a simple and user-friendly application that helps you manage and track your lottery tickets. '
                        'With this app, you can easily check the latest lottery results, save your favorite numbers, and get notifications for upcoming draws.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // "About the Developer" Card
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage('assets/icons/dev.jpg'), // Local image
                        ),
                      ),
                      SizedBox(height: 20),  // Add some space between the image and text
                      Text(
                        'About the Developer',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'The app was developed by Christian Barbosa who loves creating useful and engaging applications. '
                        'With a strong background in mobile app development, the developer aims to provide high-quality apps that enhance the user experience.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
