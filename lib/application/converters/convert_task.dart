import 'dart:convert';

import 'package:fitness_sync/application/converters/json_converter.dart';

import '../../domain/entities/tasks/task.dart';

class ConvertTaskService implements JsonConverter<Task> {
  ConvertTaskService();

  @override
  Task decode(String text) {
    return fromJson(text);
  }

  @override
  String encode(Task object) {
    return toJson(object);
  }

  String toJson(Task task) {
    return jsonEncode({
      "id": task.id,
      "name": task.name,
      "value": task.value,
      "dateTaken": task.dateTaken.toIso8601String(),
      "currentProgress": task.currentProgress,
      "timeCompleted": task.timeCompleted.toIso8601String(),
    });
  }

  Task fromJson(String text) {
    Map<String, dynamic> json = jsonDecode(text);
    return Task.full(
        id: json["id"],
        name: json["name"],
        value: json["value"],
        dateTaken: DateTime.parse(json["dateTaken"]),
        currentProgress: json["currentProgress"],
        timeCompleted: DateTime.parse(json["timeCompleted"]));
  }
}
