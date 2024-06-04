import 'package:fitness_sync/application/activity_tracker/activity_tracker_service.dart';
import 'package:fitness_sync/application/meal_planner/meal_schedule_service.dart';
import 'package:fitness_sync/application/meal_planner/user_meals_schedule.dart';
import 'package:fitness_sync/domain/entities/data/heart_rate.dart';
import 'package:fitness_sync/domain/entities/meals/meals.dart';
import 'package:flutter/material.dart';
import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';

class UserMealProvider with ChangeNotifier {
  final ActivityTrackerService _userActivityService;
  final UserMealsScheduleService _userMealService;

  UserMealProvider(UnitOfWork unitOfWork)
      : _userActivityService = ActivityTrackerService(unitOfWork: unitOfWork),
        _userMealService = UserMealsScheduleService(unitOfWork: unitOfWork);

  int _dailyCalories = 0;
  int get dailyCalories => _dailyCalories;
  Map<Nutrients, int> _dailyNutrition = {};
  Map<Nutrients, int> get dailyNutrition => _dailyNutrition;
  List<UserMeals> _meals = [];
  List<UserMeals> _dailyMeals = [];
  List<UserMeals> get meals => _meals;
  List<UserMeals> get dailyMeals => _dailyMeals;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchUserMeals(String userId, DateTime date) async {
    _isLoading = true;
    notifyListeners();
    _meals = await _userMealService.getAll(userId);
    _dailyMeals = await _userMealService.getScheduledMealsByDate(
        userId,
        DateTime(date.year, date.month, date.day, 0, 0),
        DateTime(date.year, date.month, date.day, 23, 59));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAsCompleted(UserMeals meal) async {
    _isLoading = true;
    notifyListeners();
    await _userMealService.markAsTaken(meal.id);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserNutrition(String userId) async {
    _isLoading = true;
    notifyListeners();
    _dailyNutrition =
        await _userMealService.getNutritions(userId, 1, DateTime.now());
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUser(String userId, DateTime date) async {
    _isLoading = true;
    notifyListeners();
    await fetchUserMeals(userId, date);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMeals(String userId, UserMeals statistics) async {
    _isLoading = true;
    notifyListeners();
    await _userMealService.addMealToSchedule(userId, statistics);
    _isLoading = false;
    notifyListeners();
  }
}
