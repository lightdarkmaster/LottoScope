import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
  }

  Future<void> _saveToDatabase(String numbersString) async {
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
    _loadSavedResults();
    showDialog(
      context: context as BuildContext,
      builder: (context) {
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
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
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
          content: Text('Please enter 6 valid numbers (01-42) separated by commas.'),
        ),
      );
    }
  }

void _formatInput(String value) {
  // Remove any non-numeric characters and commas
  String digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

  // Limit the input to 12 digits (6 two-digit numbers)
  if (digitsOnly.length > 12) {
    digitsOnly = digitsOnly.substring(0, 12);
  }

  // Format the input by adding commas every two digits
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

  // Update the TextField controller's text
  _inputController.value = TextEditingValue(
    text: formatted,
    selection: TextSelection.collapsed(offset: formatted.length),
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
              'Enter 6 Two-Digit Numbers (01-42) Automatically Separated by Commas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              onChanged: _formatInput,
              decoration: InputDecoration(
                hintText: 'Example: 01, 12, 23, 34, 41, 42',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _handleSave,
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
    _inputController.dispose();
    _database.close();
    super.dispose();
  }
}
