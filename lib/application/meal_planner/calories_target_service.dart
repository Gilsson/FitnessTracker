import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/data/calories_target.dart';

class CaloriesTargetService {
  late UnitOfWork unitOfWork;

  CaloriesTargetService({required this.unitOfWork});
  Future<CaloriesTarget> addCaloriesTarget(
      String userId, CaloriesTarget calories) async {
    calories.userId = userId;
    return unitOfWork.caloriesTargetRepository.add(calories);
  }

  Future<CaloriesTarget> updateCaloriesTarget(CaloriesTarget meal) {
    return unitOfWork.caloriesTargetRepository.update(meal);
  }

  Future<CaloriesTarget?> remove(int id) async {
    var calories = await unitOfWork.caloriesTargetRepository
        .getFirst([(calories) => calories.id == id]);
    if (calories != null) {
      unitOfWork.caloriesTargetRepository.remove(calories);
    }
    return calories;
  }

  Future<List<CaloriesTarget>> getAllCaloriesTargets(String userId) async {
    var allStamps = await unitOfWork.caloriesTargetRepository
        .getAllListByParams([(stamp) => stamp.userId == userId]);
    return allStamps;
  }

  Future<List<CaloriesTarget>> getCaloriesTargetsByDate(
      String userId, DateTime date, int days) async {
    DateTime endDate = date; // Assuming 'date' is the end date
    DateTime startDate = date.subtract(Duration(days: days));
    var allStamps =
        await unitOfWork.caloriesTargetRepository.getAllListByParams([
      (stamp) =>
          stamp.date.isBefore(endDate.add(Duration(days: 1))) &&
          stamp.date.isAfter(startDate.subtract(Duration(days: 1))),
      (stamp) => stamp.userId == userId
    ]);
    return allStamps;
  }

  Future<List<int>> getCaloriesTargets(
      String userId, int days, DateTime date) async {
    DateTime endDate = date; // Assuming 'date' is the end date
    DateTime startDate = date.subtract(Duration(days: days));
    var allStamps =
        await unitOfWork.caloriesTargetRepository.getAllListByParams([
      (stamp) =>
          stamp.date.isBefore(endDate.add(Duration(days: 1))) &&
          stamp.date.isAfter(startDate.subtract(Duration(days: 1))),
      (stamp) => stamp.userId == userId,
    ]);
    int today = date.weekday;
    var dayList = [0, 0, 0, 0, 0, 0, 0];
    List<DateTime> datesList =
        List.generate(7, (_) => DateTime.fromMillisecondsSinceEpoch(0));
    for (CaloriesTarget stamp in allStamps) {
      int pos = (stamp.date.weekday - today + 6) % 7;
      if (datesList[pos].isBefore(stamp.date)) {
        datesList[pos] = stamp.date;
        dayList[pos] = stamp.calories;
      }
    }
    for (int i = 1; i < 7; ++i) {
      if (dayList[i] == 0) {
        dayList[i] = dayList[i - 1];
      }
    }
    return dayList;
  }
}
