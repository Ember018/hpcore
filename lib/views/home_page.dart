import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../viewmodels/task_viewmodel.dart';

final logger = Logger();

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late TextEditingController _taskNameController;
  late TextEditingController _taskDescriptionController;
  DateTime? _selectedDueDate;
  // task list (_tasks) is in TaskViewModel

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController();
    _taskDescriptionController = TextEditingController();
    logger.i("Homepage State Initialized (View State)");
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskDescriptionController.dispose();
    logger.i("Homepage State Disposed (View State)");
    super.dispose();
  }

  Future<void> _displayAddTaskDialog(TaskViewModel viewModel) async {
    _selectedDueDate = null; // Reset date picker state
    _taskNameController.clear();
    _taskDescriptionController.clear();

    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Add Task"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: _taskNameController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: "Task Name",
                        hintText: "Your task?",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _taskDescriptionController,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        hintText: "Info about the task",
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDueDate == null
                              ? 'No due date'
                              : 'Due: ${DateFormat.yMd().format(_selectedDueDate!)}',
                        ),
                        TextButton(
                            child: const Text("Pick Date"),
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDueDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(3000),
                              );
                              if (picked != null &&
                                  picked != _selectedDueDate) {
                                setDialogState(() {
                                  _selectedDueDate = picked;
                                });
                              }
                            }),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                    child: const Text('Add'),
                    onPressed: () {
                      final String taskName = _taskNameController.text.trim();
                      final String taskDescription =
                          _taskDescriptionController.text.trim();
                      if (taskName.isNotEmpty) {
                        viewModel.addTask(
                            taskName, taskDescription, _selectedDueDate);
                        Navigator.of(context).pop();
                      } else {
                        logger.w("View attempted to add task without a name.");
                      }
                    })
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TaskViewModel>();
    final DateFormat formatter = DateFormat.yMd();

    logger.d(
        "Homepage build method executed. Task count: ${viewModel.tasks.length}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hpcore"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
          itemCount: viewModel.tasks.length,
          itemBuilder: (BuildContext context, int index) {
            if (index < 0 || index >= viewModel.tasks.length) {
              logger.w("ListView.builder invalid index: $index");
              return const SizedBox.shrink();
            }
            final task = viewModel.tasks[index];

            String dateInfo = 'Created ${formatter.format(task.creationDate)}';
            if (task.dueDate != null) {
              dateInfo += ' | Due: ${formatter.format(task.dueDate!)}';
            }

            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: task.isDone ?? false,
              onChanged: (bool? newValue) {
                if (newValue != null) {
                  viewModel.setTaskDone(index, newValue);
                }
              },
              title: Text(task.name ?? "Unnamed task",
                  style: TextStyle(
                      decoration: (task.isDone ?? false)
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: (task.isDone ?? false) ? Colors.grey : null)),
              subtitle: Text("${task.description}\n $dateInfo"),
              isThreeLine: true,
              secondary: IconButton(
                onPressed: () {
                  context.read<TaskViewModel>().removeTask(index);
                },
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                tooltip: 'Delete Task',
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final vm = context.read<TaskViewModel>();
          _displayAddTaskDialog(vm);
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
