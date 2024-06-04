import 'package:fitness_sync/domain/entities/data/data.dart';
import 'package:fitness_sync/domain/entities/tasks/task.dart';

class Achievement extends Data {
  String name = "";
  List<Task> tasksToAchieve = [];
  String description = "";
  AchievementType achievementType = AchievementType.basic;
  DateTime timeTaken = DateTime.now();
  bool completed = false;
  Achievement();
  Achievement.full(
      {required this.name,
      required this.tasksToAchieve,
      required this.description,
      required this.achievementType,
      required this.timeTaken});

//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       "name": name,
//       "tasksToAchieve": tasksToAchieve.map((e) => e.toJson()).toList(),
//       "description": description,
//       "achievementType": achievementType.customName,
//       "timeTaken": timeTaken.toIso8601String()
//     };
//   }

//   @override
//   Achievement fromJson(Map<String, dynamic> json) {
//     if (json["name"] == null ||
//         json["tasksToAchieve"] == null ||
//         json["description"] == null ||
//         json["achievementType"] == null ||
//         json["timeTaken"] == null ||
//         json["tasksToAchieve"] is! List ||
//         json["name"] is! String ||
//         json["description"] is! String ||
//         json["achievementType"] is! String ||
//         json["timeTaken"] is! String) {
//       throw FormatException("Invalid JSON format for Achievement");
//     }
//     var mock = Task();
//     var achievement = Achievement.full(
//         name: json["name"],
//         tasksToAchieve: (json["tasksToAchieve"] as List)
//             .map((e) => mock.fromJson(e))
//             .toList(),
//         description: json["description"],
//         achievementType:
//             AchievementTypeExtension.fromString(json["achievementType"]),
//         timeTaken: DateTime.parse(json["timeTaken"]));
//     return achievement;
//   }
}

enum AchievementType {
  cumulative,
  walking,
  running,
  sleeping,
  basic,
}

extension AchievementTypeExtension on AchievementType {
  String get customName {
    switch (this) {
      case AchievementType.cumulative:
        return "Cumulative";
      case AchievementType.walking:
        return "Walking";
      case AchievementType.running:
        return "Running";
      case AchievementType.sleeping:
        return "Sleeping";
      case AchievementType.basic:
        return "Basic";
    }
  }

  static AchievementType fromString(String value) {
    switch (value) {
      case "Cumulative":
        return AchievementType.cumulative;
      case "Walking":
        return AchievementType.walking;
      case "Running":
        return AchievementType.running;
      case "Sleeping":
        return AchievementType.sleeping;
      case "Basic":
        return AchievementType.basic;
      default:
        throw ArgumentError("Invalid AchievementType string: $value");
    }
  }
}
