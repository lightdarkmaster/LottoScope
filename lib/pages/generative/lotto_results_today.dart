import 'package:flutter/material.dart';

class LottoResultsToday extends StatelessWidget {
  const LottoResultsToday({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lotto Results Today', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.amber,
      ),
      body: const LottoResultsList(),
    );
  }
}

class LottoResultsList extends StatefulWidget {
  const LottoResultsList({super.key});

  @override
  _LottoResultsListState createState() => _LottoResultsListState();
}

class _LottoResultsListState extends State<LottoResultsList> {
  // This is a placeholder for the lotto results data
  // In a real application, you would fetch this data from an API
  final List<Map<String, String>> lottoResults = [
    {'category': 'Category 1', 'result': '123456'},
    {'category': 'Category 2', 'result': '654321'},
    {'category': 'Category 3', 'result': '112233'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lottoResults.length,
      itemBuilder: (context, index) {
        final result = lottoResults[index];
        return ListTile(
          title: Text(result['category']!),
          subtitle: Text('Result: ${result['result']}'),
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LottoResultsToday(),
  ));
}