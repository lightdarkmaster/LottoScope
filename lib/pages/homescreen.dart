import 'package:flutter/material.dart';
import 'package:my_lotto/pages/about.dart';
import 'package:my_lotto/pages/calendar.dart';
import 'package:my_lotto/pages/generative/gen_sixfiftyeight.dart';
import 'package:my_lotto/pages/generative/gen_sixfiftyfive.dart';
import 'package:my_lotto/pages/generative/gen_sixfortyfive.dart';
import 'package:my_lotto/pages/generative/gen_sixfortynine.dart';
import 'package:my_lotto/pages/generative/gen_sixfortytwo.dart';
import 'package:my_lotto/pages/generative/gen_suertres.dart';
import 'package:my_lotto/pages/notes.dart';
import 'package:my_lotto/pages/sixfiftyeight.dart';
import 'package:my_lotto/pages/sixfiftyfive.dart';
import 'package:my_lotto/pages/sixfortyfive.dart';
import 'package:my_lotto/pages/sixfortynine.dart';
import 'package:my_lotto/pages/sixfortytwo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/icons/appHeader.jpg',
              fit: BoxFit.cover,
            ),
            AppBar(
              title: const Text('LottoScope', style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.transparent,
              elevation: 5,
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.yellow,
                image: DecorationImage(
                  image: AssetImage('assets/icons/header.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SizedBox.shrink(), // Add an empty child
            ),
            ListTile(
              leading: Image.asset('assets/icons/pcsologo.png', width: 24, height: 24),
              title: const Text(
                'Home',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              shape: const Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            ListTile(
              leading: Image.asset('assets/icons/notes.png', width: 24, height: 24),
              title: const Text(
                'Notes',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotesPage()),
                );
              },
              shape: const Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            ListTile(
              leading: Image.asset('assets/icons/calendar.png', width: 24, height: 24),
              title: const Text(
                'Calendar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalendarPage()),
                );
              },
              shape: const Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            ListTile(
              leading: Image.asset('assets/icons/about.png', width: 24, height: 24),
              title: const Text(
                'About',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
              shape: const Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '© 2025 LottoScope. All rights reserved.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.1),
              Colors.yellow.withOpacity(0.1),
              Colors.red.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: [
              const Text(
                'Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  padding: const EdgeInsets.all(5.0), // Add padding around the grid
                  children: List.generate(6, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0), // Add padding around each card
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to different pages based on index
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => getPage(index)),
                          );
                        },
                        child: Card(
                          elevation: 4.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                getImagePath(index), // Use different images
                                width: 50.0,
                                height: 50.0,
                              ),
                              const SizedBox(height: 8.0),
                              Text(getLabel(index)), // Use different labels
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const Divider(),
              const Text(
                'Lucky Pick',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  padding: const EdgeInsets.all(5.0), // Add padding around the grid
                  children: List.generate(6, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0), // Add padding around each card
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to different pages based on index
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => getPage(index + 6)),
                          );
                        },
                        child: Card(
                          elevation: 4.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                getImagePath(index + 6), // Use different images
                                width: 50.0,
                                height: 50.0,
                              ),
                              const SizedBox(height: 8.0),
                              Text(getLabel(index + 6)), // Use different labels
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPage(int index) {
    // Return different pages based on index
    switch (index) {
      case 0:
        return const SixFortyTwo();
      case 1:
        return const SixFortyFiveHome();
      case 2:
        return const SixFortyNineHome();
      case 3:
        return const SixFiftyFiveHome();
      case 4:
        return const SixFiftyEightHome();
      case 5:
        return const SixFortyTwo();
      case 6:
        return const SixFortyTwoPage();
      case 7:
        return const SixFortyFivePage();
      case 8:
        return const SixFortyNinePage();
      case 9:
        return const SixFiftyFivePage();
      case 10:
        return const SixFiftyEightPage();
      case 11:
        return const SuertresPage(); 
      default:
        return const HomeScreen();
    }
  }

  String getImagePath(int index) {
    // Return different image paths based on index
    switch (index) {
      case 0:
        return 'assets/icons/642.png';
      case 1:
        return 'assets/icons/645.png';
      case 2:
        return 'assets/icons/649.png';
      case 3:
        return 'assets/icons/655.png';
      case 4:
        return 'assets/icons/658.png';
      case 5:
        return 'assets/icons/3d.png';
      case 6:
        return 'assets/icons/642.png';
      case 7:
        return 'assets/icons/645.png';
      case 8:
        return 'assets/icons/649.png';
      case 9:
        return 'assets/icons/655.png';
      case 10:
        return 'assets/icons/658.png';
      default:
        return 'assets/icons/3d.png';
    }
  }

  String getLabel(int index) {
    // Return different labels based on index
    switch (index) {
      case 0:
        return '6/42';
      case 1:
        return '6/45';
      case 2:
        return '6/49';
      case 3:
        return '6/55';
      case 4:
        return '6/58';
      case 5:
        return 'SuerTres';
      case 6:
        return '6/42';
      case 7:
        return '6/45';
      case 8:
        return '6/49';
      case 9:
        return '6/55';
      case 10:
        return '6/58';
      default:
        return 'SuerTres';
    }
  }
}


//need to  finish the rest of the code