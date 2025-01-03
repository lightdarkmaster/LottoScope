import 'package:flutter/material.dart';
import 'package:my_lotto/pages/generative/gen_sixfiftyeight.dart';
import 'package:my_lotto/pages/generative/gen_sixfiftyfive.dart';
import 'package:my_lotto/pages/generative/gen_sixfortyfive.dart';
import 'package:my_lotto/pages/generative/gen_sixfortynine.dart';
import 'package:my_lotto/pages/generative/gen_sixfortytwo.dart';
import 'package:my_lotto/pages/generative/gen_suertres.dart';
import 'package:my_lotto/pages/sixfortytwo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.yellowAccent.shade100,
        elevation: 5,
      ),
      body: Padding(
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
    );
  }

  Widget getPage(int index) {
    // Return different pages based on index
    switch (index) {
      case 0:
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
        return 'Generate';
      case 7:
        return 'Generate';
      case 8:
        return 'Generate';
      case 9:
        return 'Generate';
      case 10:
        return 'Generate';
      default:
        return 'SuerTres';
    }
  }
}
