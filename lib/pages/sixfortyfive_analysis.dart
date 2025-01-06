import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SixFortyFiveAnalysisPage extends StatelessWidget {
  final String analysisResult;

  const SixFortyFiveAnalysisPage({super.key, required this.analysisResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Result'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            analysisResult,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}

class SixFortyTwo extends StatefulWidget {
  const SixFortyTwo({super.key});

  @override
  _SixFortyTwoState createState() => _SixFortyTwoState();
}

class _SixFortyTwoState extends State<SixFortyTwo> {
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
      join(await getDatabasesPath(), 'lotto_results.db'),
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
    await _database.insert(
      'results',
      {'numbers': numbersString},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await _loadSavedResults();

    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      const SnackBar(content: Text('Lotto numbers saved successfully!')),
    );
  }

  Future<void> _loadSavedResults() async {
    final results = await _database.query('results');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('6/45 Lotto Results'),
        backgroundColor: Colors.redAccent,
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
                        return Card(
                          elevation: 5.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              result['numbers'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () {
                                    _inputController.text = result['numbers'];
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Edit Result'),
                                          content: TextField(
                                            controller: _inputController,
                                            keyboardType: TextInputType.number,
                                            onChanged: _formatInput,
                                            decoration: const InputDecoration(
                                                hintText: 'Edit numbers'),
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
                                  onPressed: () => _deleteResult(result['id']),
                                ),
                              ],
                            ),
                          ),
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
            backgroundColor: Colors.greenAccent,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Add 6/45 Lotto Result'),
                    content: TextField(
                      controller: _inputController,
                      keyboardType: TextInputType.number,
                      onChanged: _formatInput,
                      decoration: const InputDecoration(
                        hintText: 'Example: 01, 12, 23, 34, 41, 45',
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
                                  int.parse(number) <= 45)) {
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
                                    'Enter 6 valid numbers between 1 and 45'),
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
          const SizedBox(width: 16),
          FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            onPressed: () async {
              // Fetch the saved results from the database
              final results = await _database.query('results');

              Map<int, int> occurrences = {};

              for (var result in results) {
                final numbersString = result['numbers'] as String?;
                if (numbersString != null && numbersString.isNotEmpty) {
                  final numbers = numbersString
                      .split(',')
                      .map((e) => int.tryParse(e.trim()))
                      .where((e) => e != null && e >= 1 && e <= 45)
                      .map((e) => e!)
                      .toList();

                  for (var number in numbers) {
                    occurrences[number] = (occurrences[number] ?? 0) + 1;
                  }
                }
              }

              String analysisResult = 'Number Frequencies:\n';
              occurrences.forEach((key, value) {
                analysisResult += 'Number $key: $value times\n';
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SixFortyFiveAnalysisPage(analysisResult: analysisResult),
                ),
              );
            },
            child: const Icon(Icons.bar_chart, color: Colors.white),
          ),
        ],
      ),
    );
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
}
