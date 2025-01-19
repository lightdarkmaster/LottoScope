import 'package:flutter/material.dart';
import 'package:my_lotto/pages/notes_details.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late Database database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'notes_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT)',
        );
      },
      version: 1,
    );
    setState(() {});
  }

  Future<void> _insertNote() async {
    await database.insert(
      'notes',
      {'title': _titleController.text, 'content': _contentController.text},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _titleController.clear();
    _contentController.clear();
    setState(() {});
  }

  Future<void> _updateNote(int id, String title, String content) async {
    await database.update(
      'notes',
      {'title': title, 'content': content},
      where: 'id = ?',
      whereArgs: [id],
    );
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> _fetchNotes() async {
    return await database.query('notes');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchNotes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching notes'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No notes yet'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final note = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: const Icon(Icons.note, color: Colors.amber),
                          title: Text(
                            note['title'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            note['content'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          onTap: () {
                            // Navigate to the NoteDetailPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NoteDetailPage(
                                  title: note['title'],
                                  content: note['content'],
                                  timeSaved: DateTime.now(),
                                ),
                              ),
                            );
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _titleController.text = note['title'];
                                  _contentController.text = note['content'];
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Edit Note'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: _titleController,
                                              decoration: const InputDecoration(
                                                hintText: 'Enter title here',
                                              ),
                                            ),
                                            TextField(
                                              controller: _contentController,
                                              decoration: const InputDecoration(
                                                hintText: 'Enter content here',
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              _updateNote(note['id'], _titleController.text, _contentController.text);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Save'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await database.delete('notes', where: 'id = ?', whereArgs: [note['id']]);
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _titleController.clear();
          _contentController.clear();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('New Note'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Enter title here',
                      ),
                    ),
                    TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        hintText: 'Enter content here',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _insertNote();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    database.close();
    super.dispose();
  }
}