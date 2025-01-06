import 'package:flutter/material.dart';
import 'package:my_lotto/pages/sixfortynine_analysis.dart';
import 'package:my_lotto/pages/sixfortytwo_analysis.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SixFortyNineHome extends StatefulWidget {
  const SixFortyNineHome({super.key});

  @override
  _SixFortyNineHomeState createState() => _SixFortyNineHomeState();
}

class _SixFortyNineHomeState extends State<SixFortyNineHome> {
  late Database _database;
  List<Map<String, dynamic>> _savedResults = [];
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'lotto_results_649.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE results(id INTEGER PRIMARY KEY, numbers TEXT)',
        );
      },
      version: 1,
    );
    _loadSavedResults();
  }

  Future<void> _saveToDatabase(String numbersString) async {
    // Insert data into the database and wait for completion
    await _database.insert(
      'results',
      {'numbers': numbersString},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Reload the saved results after saving the data
    await _loadSavedResults(); // Wait for data reload before calling setState()

    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      const SnackBar(content: Text('Lotto numbers saved successfully!')),
    );
  }

  Future<void> _loadSavedResults() async {
    // Query the saved results from the database
    final results = await _database.query('results');

    // Update the UI with the fetched results by calling setState
    setState(() {
      _savedResults = results;
    });
  }

  Future<void> _deleteResult(int id) async {
    await _database.delete(
      'results',
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadSavedResults();
  }

  void _editResult(int id, String updatedNumbers) async {
    await _database.update(
      'results',
      {'numbers': updatedNumbers},
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadSavedResults();
  }

  void _handleSave() {
    final input = _inputController.text.trim();
    final numbers = input.split(',').map((e) => e.trim()).toList();

    if (numbers.length == 6 &&
        numbers.every((number) =>
            int.tryParse(number) != null &&
            int.parse(number) >= 1 &&
            int.parse(number) <= 42)) {
      final numbersString = numbers.map((n) => n.padLeft(2, '0')).join(', ');
      _saveToDatabase(numbersString);
      _inputController.clear();
    } else {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(
          content: Text('Enter 6/42 Results'),
        ),
      );
    }
  }

  void _formatInput(String value) {
    String digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length > 12) {
      digitsOnly = digitsOnly.substring(0, 12);
    }

    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i += 2) {
      if (i + 2 <= digitsOnly.length) {
        formatted += digitsOnly.substring(i, i + 2);
      } else {
        formatted += digitsOnly.substring(i);
      }
      if (i + 2 < digitsOnly.length) {
        formatted += ', ';
      }
    }

    _inputController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '6/49 Lotto Results',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.yellow,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: _savedResults.isEmpty
                    ? const Center(child: Text('No saved results.'))
                    : ListView.builder(
                        itemCount: _savedResults.length,
                        itemBuilder: (context, index) {
                          final result = _savedResults[index];
                          return Column(
                            children: [
                              ListTile(
                                title: Text(result['numbers']),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      onPressed: () {
                                        _inputController.text =
                                            result['numbers'];
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Edit Result'),
                                              content: TextField(
                                                controller: _inputController,
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: _formatInput,
                                                decoration:
                                                    const InputDecoration(
                                                        hintText:
                                                            'Edit numbers'),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    _editResult(
                                                        result['id'],
                                                        _inputController.text
                                                            .trim());
                                                  },
                                                  child: const Text('Save'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        // Show confirmation dialog before deleting
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Confirm Deletion'),
                                              content: const Text(
                                                  'Are you sure you want to delete this result?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog without deleting
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    _deleteResult(result[
                                                        'id']); // Delete the result if confirmed
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog after deletion
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 1.0,
                                thickness: 1.0,
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.redAccent,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Add 6/42 Lotto Result'),
                      content: TextField(
                        controller: _inputController,
                        keyboardType: TextInputType.number,
                        onChanged: _formatInput,
                        decoration: const InputDecoration(
                          hintText: 'Example: 01, 12, 23, 34, 41, 42',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            final input = _inputController.text.trim();
                            final numbers =
                                input.split(',').map((e) => e.trim()).toList();

                            if (numbers.length == 6 &&
                                numbers.every((number) =>
                                    int.tryParse(number) != null &&
                                    int.parse(number) >= 1 &&
                                    int.parse(number) <= 42)) {
                              final numbersString = numbers
                                  .map((n) => n.padLeft(2, '0'))
                                  .join(', ');
                              _saveToDatabase(numbersString).then((_) {
                                _loadSavedResults(); // Reload results after saving
                                _inputController
                                    .clear(); // Clear the input field after saving
                              });
                              Navigator.of(context)
                                  .pop(); // Close the dialog after saving
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Enter 6 valid numbers between 1 and 42'),
                                ),
                              );
                            }
                          },
                          child: const Text('Save'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Close the dialog if cancelled
                            _inputController
                                .clear(); // Clear the input field if cancelled
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
            const SizedBox(width: 16), // Adds some space between buttons
            FloatingActionButton(
              backgroundColor: Colors.teal,
              onPressed: () async {
                // Fetch the saved results from the database
                final results = await _database.query('results');

                // Initialize a map to store occurrences of each number
                Map<int, int> occurrences = {};

                for (var result in results) {
                  final numbersString = result['numbers']
                      as String?; // Ensure we handle null values
                  if (numbersString != null && numbersString.isNotEmpty) {
                    final numbers = numbersString
                        .split(',') // Split the numbers string by commas
                        .map((e) => int.tryParse(
                            e.trim())) // Convert to int and avoid null
                        .where((e) =>
                            e != null &&
                            e >= 1 &&
                            e <= 42) // Filter out invalid numbers
                        .map((e) =>
                            e!) // Safely unwrap after filtering out nulls
                        .toList();

                    for (var number in numbers) {
                      occurrences[number] = (occurrences[number] ?? 0) + 1;
                    }
                  }
                }

                // Prepare the analysis result
                String analysisResult = 'Number Frequencies:\n';
                occurrences.forEach((key, value) {
                  analysisResult += 'Number $key: $value times\n';
                });

                // Navigate to the analysis page with the result
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SixFortyNineAnalysisPage(analysisResult: analysisResult),
                  ),
                );
              },
              child: const Icon(Icons.bar_chart, color: Colors.white),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
