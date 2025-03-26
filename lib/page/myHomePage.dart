import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late Database _database;
  List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, isDone INTEGER)',
        );
      },
      version: 1,
    );
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final List<Map<String, dynamic>> tasks = await _database.query('tasks');
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _addTask(String title) async {
    await _database.insert('tasks', {'title': title, 'isDone': 0});
    _fetchTasks();
  }

  Future<void> _updateTask(int id, int isDone) async {
    await _database.update(
      'tasks',
      {'isDone': isDone},
      where: 'id = ?',
      whereArgs: [id],
    );
    _fetchTasks();
  }

  Future<void> _deleteTask(int id) async {
    await _database.delete('tasks', where: 'id = ?', whereArgs: [id]);
    _fetchTasks();
  }

  void _showAddTaskDialog(context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: TextField(
            controller: _taskController,
            decoration: InputDecoration(hintText: 'Enter task title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addTask(_taskController.text);
                _taskController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To-Do List')),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(
              task['title'],
              style: TextStyle(
                decoration:
                    task['isDone'] == 1 ? TextDecoration.lineThrough : null,
              ),
            ),
            trailing: Checkbox(
              value: task['isDone'] == 1,
              onChanged: (value) {
                _updateTask(task['id'], value! ? 1 : 0);
              },
            ),
            onLongPress: () => _deleteTask(task['id']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
