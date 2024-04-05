import 'package:fitness_sync/domain/entities/entity.dart';
import 'package:fitness_sync/domain/entities/tasks/task.dart';

class Achievement extends Entity {
  String name = "";
  List<Task> tasksToAchieve = [];
  String description = "";
  AchievementType achievementType = AchievementType.basic;
  DateTime timeTaken = DateTime.utc(0);
  Achievement();

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "tasksToAchieve": tasksToAchieve.map((e) => e.toMap()).toList(),
      "description": description,
      "achievementType": achievementType,
      "timeTaken": timeTaken
    };
  }
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
}
