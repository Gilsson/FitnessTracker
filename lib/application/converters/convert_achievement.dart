import 'dart:convert';

import 'package:fitness_sync/application/converters/convert_task.dart';
import 'package:fitness_sync/application/converters/json_converter.dart';
import 'package:fitness_sync/domain/entities/tasks/achievement.dart';

class ConvertAchievementsService implements JsonConverter<Achievement> {
  ConvertTaskService taskService;
  ConvertAchievementsService({required this.taskService});

  @override
  String encode(Achievement object) {
    return toJson(object);
  }

  @override
  Achievement decode(String json) {
    return fromJson(json);
  }

  String toJson(Achievement achievement) {
    return jsonEncode({
      "name": achievement.name,
      "tasksToAchieve":
          achievement.tasksToAchieve.map((e) => taskService.encode(e)).toList(),
      "description": achievement.description,
      "achievementType": achievement.achievementType.customName,
      "timeTaken": achievement.timeTaken.toIso8601String()
    });
  }

  Achievement fromJson(String text) {
    Map<String, dynamic> json = jsonDecode(text);
    if (json["name"] == null ||
        json["tasksToAchieve"] == null ||
        json["description"] == null ||
        json["achievementType"] == null ||
        json["timeTaken"] == null ||
        json["tasksToAchieve"] is! List ||
        json["name"] is! String ||
        json["description"] is! String ||
        json["achievementType"] is! String ||
        json["timeTaken"] is! String) {
      throw FormatException("Invalid JSON format for Achievement");
    }
    var achievement = Achievement.full(
        name: json["name"],
        tasksToAchieve: (json["tasksToAchieve"] as List)
            .map((e) => taskService.decode(e))
            .toList(),
        description: json["description"],
        achievementType:
            AchievementTypeExtension.fromString(json["achievementType"]),
        timeTaken: DateTime.parse(json["timeTaken"]));
    return achievement;
  }
}
