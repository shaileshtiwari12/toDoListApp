// screens/todo_list_screen.dart
import 'package:flutter/material.dart';
import 'package:text/database/database_helper.dart';
import 'package:text/models/task_model.dart';
import 'package:text/services/notification_service.dart';

class TodoListScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const TodoListScreen({super.key, required this.toggleTheme});

  @override
  // ignore: library_private_types_in_public_api
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Task> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  String _selectedCategory = 'General';
  final List<String> _categories = ['Work', 'Personal', 'General'];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
    NotificationService.init();
  }

  Future<void> _fetchTasks() async {
    final tasks = await DatabaseHelper.instance.getTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _addTask(String title, String category) async {
    final task = Task(title: title, category: category, isDone: 0);
    await DatabaseHelper.instance.insertTask(task);
    _fetchTasks();
    NotificationService.showNotification('New Task Added', title);
  }

  Future<void> _updateTask(Task task) async {
    task.isDone = task.isDone == 1 ? 0 : 1;
    await DatabaseHelper.instance.updateTask(task);
    _fetchTasks();
  }

  Future<void> _deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    _fetchTasks();
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: InputDecoration(hintText: 'Enter task title'),
              ),
              DropdownButton<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addTask(_taskController.text, _selectedCategory);
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
      appBar: AppBar(
        title: Text('To-Do List'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isDone == 1 ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(task.category),
            trailing: Checkbox(
              value: task.isDone == 1,
              onChanged: (value) {
                _updateTask(task);
              },
            ),
            onLongPress: () => _deleteTask(task.id!),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
