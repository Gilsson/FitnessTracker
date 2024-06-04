import 'package:fitness_sync/application/meal_planner/meal_schedule_service.dart';
import 'package:fitness_sync/domain/entities/meals/meals.dart';
import 'package:flutter/material.dart';
import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';

class MealProvider with ChangeNotifier {
  final MealScheduleService _mealService;

  MealProvider(UnitOfWork unitOfWork)
      : _mealService = MealScheduleService(unitOfWork: unitOfWork);
  List<Meals> _meals = [];
  List<Meals> get meals => _meals;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchMeals() async {
    _isLoading = true;
    notifyListeners();
    _meals = await _mealService.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<Meals> addMeals(Meals statistics) async {
    _isLoading = true;
    notifyListeners();
    var meal = await _mealService.addMealToSchedule(statistics);
    _isLoading = false;
    notifyListeners();
    return meal;
  }
}
