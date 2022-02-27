import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  bool taskCompleted;
  @HiveField(3)
  final DateTime datetime;

  Task(
      {required this.title,
      required this.taskCompleted,
      required this.id,
      required this.datetime});

  factory Task.create({required String name, required DateTime dateTime}) {
    return Task(
        title: name,
        taskCompleted: false,
        id: const Uuid().v1(),
        datetime: dateTime);
  }
}
