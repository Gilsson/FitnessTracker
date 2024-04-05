import 'package:fitness_sync/domain/entities/data/achievement.dart';

class CompletedAchievement extends Achievement {
  DateTime timeCompleted = DateTime.utc(0);
}
