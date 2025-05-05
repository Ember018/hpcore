import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../models/task.dart';

final logger = Logger();

class TaskViewModel extends ChangeNotifier {
  final List<Task> _tasks = [];

  // Public getter to access the tasks (unmodifiable view)
  List<Task> get tasks => _tasks;

  void addTask(String name, String description, DateTime? dueDate) {
    final newTask = Task(
        name,
        (description.isEmpty ? "No description" : description),
        DateTime.now(),
        dueDate,
        false);
    _tasks.add(newTask);
    logger.i("ViewModel added task: '$name'");
    notifyListeners(); // Notify listeners about the change
  }

  void toggleTask(int index) {
    if (index < 0 || index >= _tasks.length) return;
    _tasks[index].isDone = !(_tasks[index].isDone ?? false);
    logger.i(
        "ViewModel toggled task state: '${_tasks[index].name}': '${_tasks[index].isDone}'");
    notifyListeners();
  }

  void setTaskDone(int index, bool newValue) {
    if (index < 0 || index >= _tasks.length) return; // Safety check
    _tasks[index].isDone = newValue;
    logger.i(
        "ViewModel set task state: '${_tasks[index].name}': '${_tasks[index].isDone}'");
    notifyListeners();
  }

  void removeTask(int index) {
    if (index < 0 || index >= _tasks.length) {
      logger.e("ViewModel attempted to remove task with invalid index: $index");
      return;
    }
    final removedTaskName = _tasks[index].name ?? "Unnamed Task";
    _tasks.removeAt(index);
    logger.i("ViewModel removed task: '$removedTaskName'");
    notifyListeners();
  }
}
