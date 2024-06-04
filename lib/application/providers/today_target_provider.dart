import 'package:fitness_sync/application/activity_tracker/activity_tracker_service.dart';
import 'package:fitness_sync/application/meal_planner/calories_target_service.dart';
import 'package:fitness_sync/application/meal_planner/meal_schedule_service.dart';
import 'package:fitness_sync/application/meal_planner/user_meals_schedule.dart';
import 'package:fitness_sync/application/sleep_planner/sleep_planner_service.dart';
import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/data/calories_target.dart';
import 'package:fitness_sync/domain/entities/data/heart_rate.dart';
import 'package:fitness_sync/domain/entities/data/sleep_data.dart';
import 'package:fitness_sync/domain/entities/data/step_data.dart';
import 'package:fitness_sync/domain/entities/data/workout.dart';
import 'package:fitness_sync/domain/entities/meals/meals.dart';
import 'package:fitness_sync/domain/entities/water/water.dart';
import 'package:flutter/material.dart';

class TodayTargetProvider with ChangeNotifier {
  late SleepPlannerService _sleepPlannerService;
  late ActivityTrackerService _activityTrackerService;
  late UserMealsScheduleService _mealScheduleService;
  late CaloriesTargetService _caloriesTargetService;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<SleepData> _sleepTargets = [];
  List<Water> _waterTargets = [];
  List<CaloriesTarget> _caloriesTargets = [];
  List<StepData> _stepTargets = [];
  List<Workout> _workoutTargets = [];
  List<int> _sleep = [];
  List<int> _water = [];
  List<int> _calories = [];
  List<int> _step = [];
  List<int> _workout = [];
  List<double> _targetsList = [0, 0, 0, 0, 0, 0, 0];

  List<SleepData> get sleepTargets => _sleepTargets;
  List<Water> get waterTargets => _waterTargets;
  List<CaloriesTarget> get caloriesTargets => _caloriesTargets;
  List<StepData> get stepTargets => _stepTargets;
  List<Workout> get workoutTargets => _workoutTargets;
  List<double> get targetsList => _targetsList;
  List<int> get sleep => _sleep;
  List<int> get water => _water;
  List<int> get calories => _calories;
  List<int> get step => _step;
  List<int> get workout => _workout;

  TodayTargetProvider(UnitOfWork unitOfWork)
      : _sleepPlannerService = SleepPlannerService(unitOfWork: unitOfWork),
        _activityTrackerService =
            ActivityTrackerService(unitOfWork: unitOfWork),
        _mealScheduleService = UserMealsScheduleService(unitOfWork: unitOfWork),
        _caloriesTargetService = CaloriesTargetService(unitOfWork: unitOfWork);

  Future<void> fetchTargets(String userId) async {
    _isLoading = true;

    notifyListeners();
    _sleepTargets = await _sleepPlannerService.getScheduledSleep(userId);
    _sleepTargets.sort((a, b) => a.date.compareTo(b.date));
    _stepTargets = await _activityTrackerService.getScheduledSteps(userId);
    _stepTargets.sort((a, b) => a.date.compareTo(b.date));
    _waterTargets = await _activityTrackerService.getScheduledWater(userId);
    _waterTargets.sort((a, b) => a.dateTaken.compareTo(b.dateTaken));
    _caloriesTargets =
        await _caloriesTargetService.getAllCaloriesTargets(userId);
    _caloriesTargets.sort((a, b) => a.date.compareTo(b.date));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTargetSleep(String userId, SleepData sleepData) async {
    _isLoading = true;
    notifyListeners();
    await _sleepPlannerService.addSleepData(userId, sleepData);
    await fetchTargets(userId); // Fetch updated data
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTargetCalories(String userId, CaloriesTarget target) async {
    _isLoading = true;
    notifyListeners();
    await _caloriesTargetService.addCaloriesTarget(userId, target);
    await fetchTargets(userId); // Fetch updated data
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTargetStep(String userId, StepData stepData) async {
    _isLoading = true;
    notifyListeners();
    await _activityTrackerService.addSteps(userId, stepData);
    await fetchTargets(userId); // Fetch updated data
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTargetWater(String userId, Water water) async {
    _isLoading = true;
    notifyListeners();
    await _activityTrackerService.addWaterData(userId, water);
    await fetchTargets(userId); // Fetch updated data
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCalories(String userId) async {
    _isLoading = true;
    notifyListeners();
    _calories = await _mealScheduleService.getCaloriesPerDays(
        userId, 7, DateTime.now());
    notifyListeners();
  }

  Future<void> fetchWeekGoals(String userId) async {
    _isLoading = true;
    notifyListeners();
    await fetchTargets(userId); // Fetch updated data
    _sleep = await _sleepPlannerService.getSleepContinuityPerDays(
        userId, 7, DateTime.now());
    var scheduledData = await _sleepPlannerService
        .getScheduledSleepContinuityPerDays(userId, 7, DateTime.now());
    var sleep = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    for (int i = 0; i < 7; ++i) {
      sleep[i] = (_sleep[i].toDouble() / (scheduledData[i] + 1).toDouble())
          .clamp(0.0, 1.0);
    }
    _step = await _activityTrackerService.getStepsPerDays(
        userId, 7, DateTime.now());
    var scheduledStepsData = await _activityTrackerService
        .getScheduledStepsPerDays(userId, 7, DateTime.now());
    var step = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    for (int i = 0; i < 7; ++i) {
      step[i] = (_step[i] / (scheduledStepsData[i] + 1)).clamp(0.0, 1.0);
    }
    _water = await _activityTrackerService.getWaterPerDays(
        userId, 7, DateTime.now());
    var scheduledWaterData = await _activityTrackerService
        .getScheduledWaterPerDays(userId, 7, DateTime.now());
    var water = List<double>.generate(7, (_) => 0.0);
    for (int i = 0; i < 7; ++i) {
      water[i] = (_water[i] / (scheduledWaterData[i] + 1)).clamp(0.0, 1.0);
    }

    _calories = await _mealScheduleService.getCaloriesPerDays(
        userId, 7, DateTime.now());
    var scheduledCaloriesData = await _caloriesTargetService.getCaloriesTargets(
        userId, 7, DateTime.now());
    var calories = List<double>.generate(7, (_) => 0.0);
    for (int i = 0; i < 7; ++i) {
      calories[i] =
          (_calories[i] / (scheduledCaloriesData[i] + 1)).clamp(0.0, 1.0);
    }

    for (int i = 0; i < 7; ++i) {
      _targetsList[i] =
          ((sleep[i] + step[i] + water[i] + calories[i]) / 4.0).clamp(0.0, 1.0);
    }

    _isLoading = false;
    notifyListeners();
  }
}
