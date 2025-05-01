import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Simple TODO App', // The app's title
        theme: ThemeData(
          primarySwatch: Colors.yellow, // Main theme color
          useMaterial3: true, // Optional: Use Material 3 design
        ),
        home: const TodoListScreen());
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItem> _tasks = [
    TodoItem(title: "Learn Flutter"),
    TodoItem(title: "From a Place of Love", isDone: true),
  ];

  final TextEditingController _textFieldController = TextEditingController();

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  Future<void> _displayAddTaskDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new task'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Enter task here...'),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                String newTaskTitle = _textFieldController.text;
                if (newTaskTitle.isNotEmpty) {
                  final newItem = TodoItem(title: newTaskTitle);
                  setState(() {
                    _tasks.add(newItem);
                  });

                  _textFieldController.clear();

                  Navigator.pop(context);
                } else {}
              },
            ),
          ],
        );
      },
    );
  }

  // controllers need to be disposed of when the stateful widget is removed to prevent memory leaks
  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My TODO List'),
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text("No tasks yet!"))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return CheckboxListTile(
                  title: Text(task.title),
                  value: task.isDone,
                  onChanged: (bool? newValue) {
                    setState(() {
                      task.isDone = newValue!;
                    });
                  },
                  secondary: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      _removeTask(index);
                    },
                    tooltip: 'Delete Task',
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          logger.i("pressed");
          _displayAddTaskDialog(context);
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoItem {
  String title;
  bool isDone;

  TodoItem({required this.title, this.isDone = false});
}
