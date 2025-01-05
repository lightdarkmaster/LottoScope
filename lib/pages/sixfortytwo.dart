import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class SixFortyTwo extends StatefulWidget {
  const SixFortyTwo({super.key});

  @override
  _SixFortyTwoState createState() => _SixFortyTwoState();
}

class _SixFortyTwoState extends State<SixFortyTwo> {
  final List<String> _numbers = List.filled(6, '');
  late Database _database;
  List<Map<String, dynamic>> _savedResults = [];

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
  }

  Future<void> _saveToDatabase() async {
    final numbersString = _numbers.join(', ');
    await _database.insert(
      'results',
      {'numbers': numbersString},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      const SnackBar(content: Text('Lotto numbers saved successfully!')),
    );
    _loadSavedResults();
  }

  Future<void> _loadSavedResults() async {
    final results = await _database.query('results');
    setState(() {
      _savedResults = results;
    });
  }

  void _showSavedResultsDialog() {
    _loadSavedResults(); // Refresh results
    showDialog(
      context: context as BuildContext,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Saved Lotto Results'),
          content: _savedResults.isEmpty
              ? const Text('No saved results found.')
              : SizedBox(
                  height: 200,
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: _savedResults.length,
                    itemBuilder: (context, index) {
                      final result = _savedResults[index];
                      return ListTile(
                        title: Text('Entry ${result['id']}: ${result['numbers']}'),
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context as BuildContext).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('6/42 Lotto Results', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Enter 6 Two-Digit Numbers (01-42)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Number ${index + 1}',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (value) {
                        if (int.tryParse(value) != null &&
                            int.parse(value) >= 1 &&
                            int.parse(value) <= 42) {
                          _numbers[index] = value.padLeft(2, '0');
                        } else {
                          _numbers[index] = '';
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_numbers.contains('')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter all 6 numbers!')),
                      );
                    } else {
                      _saveToDatabase();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 18)),
                ),
                ElevatedButton(
                  onPressed: _showSavedResultsDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  ),
                  child: const Text('View Saved', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }
}
