import 'package:logger/logger.dart';

final logger = Logger();

class Task {
  String? name;
  String description;
  final DateTime creationDate;
  DateTime? dueDate;
  bool? isDone;

  Task(this.name, this.description, this.creationDate, this.dueDate,
      this.isDone) {
    isDone ??= false; // Default null isDone to false
    if (description.trim().isEmpty) {
      description = "No description";
    }
  }

  void displayTaskInfo() {
    logger.i("Task name: $name");
    logger.i("Description: $description");
    logger.i("Created: $creationDate");
    logger.i("Due: ${dueDate?.toString() ?? 'N/A'}");
    logger.i("Status: ${isDone == true ? "done" : "not done"}");
  }
}
