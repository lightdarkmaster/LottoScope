import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Suertres {
  final Random _random = Random();

  List<String> generateNumbers() {
    Set<int> numbers = {};
    while (numbers.length < 1) {
      int number = _random.nextInt(999) + 1;
      numbers.add(number);
    }
    return numbers.map((number) => number.toString().padLeft(3, '0')).toList();
  }
}

class SuertresPage extends StatefulWidget {
  const SuertresPage({super.key});

  @override
  SuertresPageState createState() => SuertresPageState();
}

class SuertresPageState extends State<SuertresPage> {
  final Suertres _generator = Suertres();
  List<String> _generatedNumbers = [];
  final List<List<String>> _recentNumbers = [];

  void _generateNumbers() {
    setState(() {
      _generatedNumbers = _generator.generateNumbers();
      _recentNumbers.insert(0, _generatedNumbers);
      if (_recentNumbers.length > 5) {
        _recentNumbers.removeLast();
      }
    });
  }

  void _copyToClipboard(String numbers) {
    Clipboard.setData(ClipboardData(text: numbers));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suertres Generator'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 400,
                  height: 350,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.red, width: 2),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _generateNumbers,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            child: const Text('Generate Suertres Numbers', style: TextStyle(color: Colors.black),),
                          ),
                          const SizedBox(height: 20),
                          if (_generatedNumbers.isNotEmpty)
                            Column(
                              children: [
                                const Text(
                                  'Generated Numbers:',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        _generatedNumbers.join(', '),
                                        style: const TextStyle(fontSize: 23, color: Colors.red),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.copy, color: Colors.red),
                                      onPressed: () => _copyToClipboard(_generatedNumbers.join(', ')),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  height: 200,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.red, width: 2),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Recent Numbers:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _recentNumbers.length,
                              itemBuilder: (context, index) {
                                final numbers = _recentNumbers[index].join(', ');
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          numbers,
                                          style: const TextStyle(fontSize: 18, color: Colors.red),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.copy, color: Colors.red),
                                      onPressed: () => _copyToClipboard(numbers),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
