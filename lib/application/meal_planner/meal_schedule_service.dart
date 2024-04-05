import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/meals/meals.dart';

class MealScheduleService {
  late UnitOfWork unitOfWork;

  MealScheduleService({required this.unitOfWork});
  Future<Meals> addMealToSchedule(int userId, Meals meals) async {
    meals.userId = userId;
    return unitOfWork.mealRepository.add(meals);
  }

  Future<Meals> updateMealSchedule(Meals meal) {
    return unitOfWork.mealRepository.update(meal);
  }

  Future<Meals?> remove(int id) async {
    var meal =
        await unitOfWork.mealRepository.getFirst([(meal) => meal.id == id]);
    if (meal != null) {
      unitOfWork.mealRepository.remove(meal);
    }
    return meal;
  }

  Future<Meals?> markAsTaken(int id) async {
    var meal =
        await unitOfWork.mealRepository.getFirst([(meal) => meal.id == id]);
    if (meal != null) {
      meal.isCompleted = true;
      unitOfWork.mealRepository.update(meal);
    }
    return meal;
  }

  Future<List<Meals>> getScheduledMeals(int userId) async {
    return await unitOfWork.mealRepository.getAllListByParams([
      (meal) => !meal.isCompleted,
      (meal) => meal.userId == userId,
      (meal) => meal.timeTaken.isBefore(DateTime.now())
    ]);
  }

  Future<List<Meals>> getFutureMeals(int userId, DateTime from) async {
    return await unitOfWork.mealRepository.getAllListByParams([
      (meal) => meal.userId == userId,
      (meal) => meal.timeTaken.isAfter(from)
    ]);
  }

  Future<List<Meals>> getByTypeAndDay(
      int userId, MealType type, DateTime date) async {
    return unitOfWork.mealRepository.getAllListByParams([
      (meal) =>
          meal.mealType == type &&
          meal.timeTaken.day == date.day &&
          meal.userId == userId
    ]);
  }

  Future<Meals?> getById(int userId, int id) async {
    return unitOfWork.mealRepository
        .getFirst([(meal) => meal.id == id && meal.userId == userId]);
  }

  Future<Map<String, int>> getNutritions(int userId, int days, DateTime date) {
    var allMeals = unitOfWork.mealRepository.getAllListByParams([
      (meal) =>
          meal.timeTaken.day <= date.day &&
          meal.timeTaken.day >= date.day - days &&
          meal.userId == userId
    ]);
    return allMeals.then((meals) {
      Map<String, int> result = {};
      for (var meal in meals) {
        for (String type in meal.nutrients.keys) {
          if (!result.containsKey(type)) {
            result[type] = 0;
          }
          result[type] = result[type]! + meal.nutrients[type]!;
        }
      }
      return result;
    });
  }

  Future<int> getCalories(int userId, int days, DateTime date) {
    var allMeals = unitOfWork.mealRepository.getAllListByParams([
      (meal) =>
          meal.timeTaken.day <= date.day &&
          meal.timeTaken.day >= date.day - days &&
          meal.userId == userId
    ]);
    return allMeals.then((meals) {
      int result = 0;
      for (var meal in meals) {
        result = result + meal.calories;
      }
      return result;
    });
  }

  Future<int> getTimedCaloriesByType(
      int userId, int days, MealType type, DateTime date) {
    var allMeals = unitOfWork.mealRepository.getAllListByParams([
      (meal) =>
          meal.mealType == type &&
          meal.timeTaken.day == date.day &&
          meal.userId == userId &&
          meal.timeTaken.day <= date.day &&
          meal.timeTaken.day >= date.day - days
    ]);
    return allMeals.then((meals) {
      int result = 0;
      for (var meal in meals) {
        result = result + meal.calories;
      }
      return result;
    });
  }

  Future<List<Meals>> getAll(int userId) {
    return unitOfWork.mealRepository
        .getAllListByParams([(meal) => meal.userId == userId]);
  }

  Future<List<Meals>> getAllByNutritionUser(
      int userId, String type, DateTime date) {
    return unitOfWork.mealRepository
        .getAllListByParams([(meal) => meal.userId == userId]);
  }

  Future<List<Meals>> getNotifications(int userId) {
    return unitOfWork.mealRepository.getAllListByParams([
      (meal) => meal.userId == userId,
      (meal) => meal.timeTaken.isAfter(DateTime.now())
    ]);
  }
}
