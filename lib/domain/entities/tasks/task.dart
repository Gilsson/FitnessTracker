import 'package:fitness_sync/domain/Entities/entity.dart';

class Task extends Entity {
  String name = "";
  String value = "";
  DateTime dateTaken = DateTime.utc(0);
  String currentProgress = "";
  DateTime timeCompleted = DateTime.utc(0);

  Task();
  Task.full(
      {required id,
      required this.name,
      required this.value,
      required this.dateTaken,
      required this.currentProgress,
      required this.timeCompleted})
      : super.withId(id);
}
