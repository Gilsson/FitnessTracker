import 'package:fitness_sync/domain/Entities/entity.dart';

class Task extends Entity {
  String name = "";
  String value = "";
  DateTime dateTaken = DateTime.utc(0);
  String currentProgress = "";
  DateTime timeCompleted = DateTime.utc(0);

  Task();
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "value": value,
      "dateTaken": dateTaken,
      "currentProgress": currentProgress,
      "timeCompleted": timeCompleted,
    };
  }
}
