import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/tasks/achievement.dart';
import 'package:fitness_sync/domain/entities/tasks/task.dart';

class AchievementService {
  late UnitOfWork unitOfWork;

  AchievementService({required this.unitOfWork});

  Future<Achievement?> getById(int id) {
    return unitOfWork.achievementRepository.getFirst([(item) => item.id == id]);
  }

  Future<List<Achievement>> getAchievements(String userId) {
    return unitOfWork.achievementRepository
        .getAllListByParams([(item) => item.userId == userId]);
  }

  Future<List<Achievement>> getAchievementsByType(
      String userId, AchievementType type) {
    return unitOfWork.achievementRepository.getAllListByParams([
      (item) => item.userId == userId,
      (item) => item.achievementType == type
    ]);
  }

  Future<List<int>> getAchievementsStatistics(
      String userId, AchievementType type) async {
    var list = await unitOfWork.achievementRepository
        .getAllListByParams([(item) => item.achievementType == type]);
    var user_list = await unitOfWork.achievementRepository.getAllListByParams([
      (item) => item.achievementType == type,
      (item) => item.userId == userId
    ]);
    int totalAchievements = list.length;
    int userAchievements = user_list.length;

    return [totalAchievements, userAchievements];
  }

  Future<Achievement> addAchievement(String userId, Achievement achievement) {
    achievement.userId = userId;
    return unitOfWork.achievementRepository.add(achievement);
  }

  Future<Achievement> updateAchievement(Achievement achievement) {
    return unitOfWork.achievementRepository.update(achievement);
  }

  Future<void> removeAchievement(Achievement achievement) {
    return unitOfWork.achievementRepository.remove(achievement);
  }

  Future<void> completeTask(
      Achievement achievement, String userId, Task task) async {
    Task upd = achievement.tasksToAchieve
        .firstWhere((element) => element.id == task.id, orElse: () => Task());
    if (upd.dateTaken != DateTime.utc(0)) {
      upd.timeCompleted = DateTime.now();
      upd.currentProgress = "100";
    }
  }

  Future<Achievement> markAsCompleted(Achievement achievement) {
    achievement.completed = true;
    return unitOfWork.achievementRepository.update(achievement);
  }
}
