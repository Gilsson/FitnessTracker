import 'package:fitness_sync/application/meal_planner/meal_schedule_service.dart';
import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/meals/meals.dart';

class UserMealsScheduleService {
  late UnitOfWork unitOfWork;
  late MealScheduleService mealScheduleService;

  UserMealsScheduleService({required this.unitOfWork})
      : mealScheduleService = MealScheduleService(unitOfWork: unitOfWork);
  Future<UserMeals> addMealToSchedule(String userId, UserMeals meals) async {
    meals.userId = userId;
    return unitOfWork.userMealRepository.add(meals);
  }

  Future<UserMeals> updateMealSchedule(UserMeals meal) {
    return unitOfWork.userMealRepository.update(meal);
  }

  Future<UserMeals?> remove(int id) async {
    var meal =
        await unitOfWork.userMealRepository.getFirst([(meal) => meal.id == id]);
    if (meal != null) {
      unitOfWork.userMealRepository.remove(meal);
    }
    return meal;
  }

  Future<UserMeals?> markAsTaken(String id) async {
    var meal =
        await unitOfWork.userMealRepository.getFirst([(meal) => meal.id == id]);
    if (meal != null) {
      meal.completed = true;
      unitOfWork.userMealRepository.update(meal);
    }
    return meal;
  }

  Future<List<UserMeals>> getScheduledMeals(String userId) async {
    return await unitOfWork.userMealRepository.getAllListByParams([
      (meal) => !meal.completed,
      (meal) => meal.userId == userId,
      (meal) => meal.date.isBefore(DateTime.now()),
      (stamp) => !stamp.completed
    ]);
  }

  Future<List<UserMeals>> getMealsByDate(
      String userId, DateTime date, int days) async {
    DateTime endDate = date; // Assuming 'date' is the end date
    DateTime startDate = date.subtract(Duration(days: days));
    var allStamps = await unitOfWork.userMealRepository.getAllListByParams([
      (stamp) =>
          stamp.date.isBefore(endDate.add(Duration(days: 1))) &&
          stamp.date.isAfter(startDate.subtract(Duration(days: 1))),
      (stamp) => stamp.userId == userId,
      (stamp) => stamp.isScheduled == false,
      (stamp) => !stamp.completed
    ]);
    return allStamps;
  }

  Future<List<UserMeals>> getScheduledMealsByDate(
      String userId, DateTime start, DateTime end) async {
    var allStamps = await unitOfWork.userMealRepository.getAllListByParams([
      (stamp) => stamp.date.isBefore(end) && stamp.date.isAfter(start),
      (stamp) => stamp.userId == userId,
      (stamp) => stamp.isScheduled == true,
      (stamp) => !stamp.completed
    ]);
    return allStamps;
  }

  Future<List<UserMeals>> getScheduledCalories(String userId) {
    return unitOfWork.userMealRepository.getAllListByParams([
      (data) => data.isScheduled == true,
      (data) => data.userId == userId,
      (stamp) => !stamp.completed
    ]);
  }

  Future<List<UserMeals>> getFutureMeals(String userId, DateTime from) async {
    return await unitOfWork.userMealRepository.getAllListByParams(
        [(meal) => meal.userId == userId, (meal) => meal.date.isAfter(from)]);
  }

  Future<List<int>> getCaloriesPerDays(
      String userId, int days, DateTime date) async {
    DateTime endDate = date; // Assuming 'date' is the end date
    DateTime startDate = date.subtract(Duration(days: days));
    var allStamps = await unitOfWork.userMealRepository.getAllListByParams([
      (stamp) =>
          stamp.date.isBefore(endDate.add(Duration(days: 1))) &&
          stamp.date.isAfter(startDate.subtract(Duration(days: 1))),
      (stamp) => stamp.userId == userId,
    ]);
    int today = date.weekday;
    var dayList = [0, 0, 0, 0, 0, 0, 0];
    for (UserMeals stamp in allStamps) {
      int pos = (stamp.date.weekday - today + 6) % 7;
      dayList[pos] += stamp.meal.calories;
    }
    return dayList;
  }

  Future<List<int>> getScheduledCaloriesPerDays(
      String userId, int days, DateTime date) async {
    DateTime endDate = date; // Assuming 'date' is the end date
    DateTime startDate = date.subtract(Duration(days: days));
    var allStamps = await unitOfWork.userMealRepository.getAllListByParams([
      (stamp) =>
          stamp.date.isBefore(endDate.add(Duration(days: 1))) &&
          stamp.date.isAfter(startDate.subtract(Duration(days: 1))),
      (stamp) => stamp.userId == userId,
      (stamp) => stamp.isScheduled == true
    ]);
    int today = date.weekday;
    var dayList = [0, 0, 0, 0, 0, 0, 0];
    List<DateTime> datesList =
        List.generate(7, (_) => DateTime.fromMillisecondsSinceEpoch(0));
    for (UserMeals stamp in allStamps) {
      int pos = (stamp.date.weekday - today + 6) % 7;
      if (datesList[pos].isBefore(stamp.date)) {
        datesList[pos] = stamp.date;
        dayList[pos] = stamp.meal.calories;
      }
    }
    for (int i = 1; i < 7; ++i) {
      if (dayList[i] == 0) {
        dayList[i] = dayList[i - 1];
      }
    }
    return dayList;
  }

  Future<List<UserMeals>> getByTypeAndDay(
      String userId, MealType type, DateTime date) async {
    return unitOfWork.userMealRepository.getAllListByParams([
      (meal) =>
          meal.meal.mealType == type &&
          meal.date.day == date.day &&
          meal.userId == userId
    ]);
  }

  Future<UserMeals?> getById(String userId, int id) async {
    return unitOfWork.userMealRepository
        .getFirst([(meal) => meal.id == id && meal.userId == userId]);
  }

  Future<Map<Nutrients, int>> getNutritions(
      String userId, int days, DateTime date) {
    var allMeals = unitOfWork.userMealRepository.getAllListByParams([
      (meal) =>
          meal.date.day <= date.day &&
          meal.date.day >= date.day - days &&
          meal.userId == userId
    ]);
    return allMeals.then((meals) {
      Map<Nutrients, int> result = {};
      for (var meal in meals) {
        for (Nutrients type in meal.meal.nutrients.keys) {
          if (!result.containsKey(type)) {
            result[type] = 0;
          }
          result[type] = result[type]! + meal.meal.nutrients[type]!;
        }
      }
      return result;
    });
  }

  Future<int> getCalories(String userId, int days, DateTime date) {
    var allMeals = unitOfWork.userMealRepository.getAllListByParams([
      (meal) =>
          meal.date.day <= date.day &&
          meal.date.day >= date.day - days &&
          meal.userId == userId
    ]);
    return allMeals.then((meals) {
      int result = 0;
      for (var meal in meals) {
        result = result + meal.meal.calories;
      }
      return result;
    });
  }

  Future<int> getTimedCaloriesByType(
      String userId, int days, MealType type, DateTime date) {
    var allMeals = unitOfWork.userMealRepository.getAllListByParams([
      (meal) =>
          meal.meal.mealType == type &&
          meal.date.day == date.day &&
          meal.userId == userId &&
          meal.date.day <= date.day &&
          meal.date.day >= date.day - days
    ]);
    return allMeals.then((meals) {
      int result = 0;
      for (var meal in meals) {
        result = result + meal.meal.calories;
      }
      return result;
    });
  }

  Future<List<UserMeals>> getAll(String userId) {
    return unitOfWork.userMealRepository
        .getAllListByParams([(meal) => meal.userId == userId]);
  }

  Future<List<UserMeals>> getAllByNutritionUser(
      String userId, String type, DateTime date) {
    return unitOfWork.userMealRepository
        .getAllListByParams([(meal) => meal.userId == userId]);
  }

  Future<List<UserMeals>> getNotifications(String userId) {
    return unitOfWork.userMealRepository.getAllListByParams([
      (meal) => meal.userId == userId,
      (meal) => meal.date.isAfter(DateTime.now())
    ]);
  }
}
