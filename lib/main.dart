import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart'; // Import the uuid package

final logger = Logger();

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Hpcore', // The app's title
        theme: ThemeData(
          primarySwatch: Colors.yellow, // Main theme color
          useMaterial3: true, // Optional: Use Material 3 design
        ),
        home: const TasksScreen());
  }
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<Task> _tasks = [];

  final TextEditingController _textFieldController = TextEditingController();

  TaskType _selectedTaskType = TaskType.indulge;

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  Future<void> _displayAddTaskDialog(BuildContext context) async {
    TaskType dialogSelectedType = _selectedTaskType;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        _textFieldController.clear();
        return AlertDialog(
          title: const Text('Add a new task'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter dialogSetState) {
            return SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                TextField(
                  controller: _textFieldController,
                  decoration:
                      const InputDecoration(hintText: "Enter task here"),
                  autofocus: true,
                ),
                RadioListTile<TaskType>(
                    title: const Text('Thrive'),
                    value: TaskType.thrive,
                    groupValue: dialogSelectedType,
                    onChanged: (TaskType? value) {
                      if (value != null) {
                        dialogSetState(() {
                          dialogSelectedType = value;
                        });
                      }
                    }),
                RadioListTile<TaskType>(
                    title: const Text('Endure'),
                    value: TaskType.endure,
                    groupValue: dialogSelectedType,
                    onChanged: (TaskType? value) {
                      if (value != null) {
                        dialogSetState(() {
                          dialogSelectedType = value;
                        });
                      }
                    }),
                RadioListTile<TaskType>(
                    title: const Text('Indulge'),
                    value: TaskType.indulge,
                    groupValue: dialogSelectedType,
                    onChanged: (TaskType? value) {
                      if (value != null) {
                        dialogSetState(() {
                          dialogSelectedType = value;
                        });
                      }
                    }),
                RadioListTile<TaskType>(
                    title: const Text('Release'),
                    value: TaskType.release,
                    groupValue: dialogSelectedType,
                    onChanged: (TaskType? value) {
                      if (value != null) {
                        dialogSetState(() {
                          dialogSelectedType = value;
                        });
                      }
                    }),
              ]),
            );
          }),
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
                  final newItem = Task(title: newTaskTitle);
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

var uuid = const Uuid();

enum TaskType {
  thrive, // high consequence, high satisfaction
  endure, // high consequence, low satisfaction
  indulge, // low consequence, high satisfaction
  release, // low consequence, low satisfaction
}

class Task {
  final String id;
  String title;
  String? description;
  bool isDone;
  TaskType taskType;
  DateTime? dueDate;
  DateTime creationDate;
  List<String>? tags;

  Task(
      {required this.title,
      this.description,
      this.isDone = false,
      this.taskType = TaskType.endure,
      this.dueDate,
      this.tags})
      : id = uuid.v4(),
        creationDate = DateTime.now(); // Generate unique id on creation

  void toggleDone() {
    isDone = !isDone;
  }

  // for debugging/ logging
  @override
  String toString() {
    return 'Task(id: $id, title: "$title", isDone: $isDone, taskType: $taskType, dueDate: $dueDate, creationDate: $creationDate)';
  }
}
