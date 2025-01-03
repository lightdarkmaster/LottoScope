import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SixFiftyFive {
  final Random _random = Random();

  List<String> generateNumbers() {
    Set<int> numbers = {};
    while (numbers.length < 6) {
      int number = _random.nextInt(55) + 1;
      numbers.add(number);
    }
    return numbers.map((number) => number.toString().padLeft(2, '0')).toList();
  }
}

class SixFiftyFivePage extends StatefulWidget {
  const SixFiftyFivePage({super.key});

  @override
  _SixFiftyFivePageState createState() => _SixFiftyFivePageState();
}

class _SixFiftyFivePageState extends State<SixFiftyFivePage> {
  final SixFiftyFive _generator = SixFiftyFive();
  List<String> _generatedNumbers = [];
  List<List<String>> _recentNumbers = [];

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
        title: const Text('6/55 Generator'),
        backgroundColor: Colors.amber,
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
                      side: const BorderSide(color: Colors.amber, width: 2),
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
                              backgroundColor: Colors.amber,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            child: const Text('Generate 6/55 Numbers', style: TextStyle(color: Colors.black),),
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
                      side: const BorderSide(color: Colors.amberAccent, width: 2),
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
