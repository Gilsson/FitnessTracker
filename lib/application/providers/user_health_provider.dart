import 'package:fitness_sync/application/activity_tracker/activity_tracker_service.dart';
import 'package:fitness_sync/application/sleep_planner/sleep_planner_service.dart';
import 'package:fitness_sync/application/user/user_service.dart';
import 'package:fitness_sync/application/user/user_statistics_service.dart';
import 'package:fitness_sync/domain/entities/data/heart_rate.dart';
import 'package:fitness_sync/domain/entities/data/sleep_data.dart';
import 'package:fitness_sync/domain/entities/data/step_data.dart';
import 'package:fitness_sync/domain/entities/water/water.dart';
import 'package:flutter/material.dart';
import 'package:fitness_sync/domain/entities/data/statistics.dart';
import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';

class UserHealthProvider with ChangeNotifier {
  final ActivityTrackerService _userActivityService;
  final SleepPlannerService _userSleepService;

  UserHealthProvider(UnitOfWork unitOfWork)
      : _userActivityService = ActivityTrackerService(unitOfWork: unitOfWork),
        _userSleepService = SleepPlannerService(unitOfWork: unitOfWork);

  List<HeartRateData>? _heartRate = [];
  List<HeartRateData>? get heartRate => _heartRate;

  List<StepData>? _steps = [];
  List<StepData>? get steps => _steps;

  List<Water>? _water = [];
  List<Water>? get water => _water;

  List<SleepData> _sleep = [];
  List<SleepData> get sleep => _sleep;

  Duration _sleepHours = Duration.zero;
  Duration get sleepHours => _sleepHours;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchUserHeartRate(String userId) async {
    _isLoading = true;
    notifyListeners();
    _heartRate =
        await _userActivityService.getHeartRate(userId, DateTime.now(), 1);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserSteps(String userId) async {
    _isLoading = true;
    notifyListeners();
    _steps = await _userActivityService.getStepsByDate(
        userId, DateTime.now().subtract(Duration(days: 1)), DateTime.now());
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserWater(String userId) async {
    _isLoading = true;
    notifyListeners();
    _water = await _userActivityService.getWaterByDate(
        userId, DateTime.now().subtract(Duration(days: 1)), DateTime.now());
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserSleep(String userId) async {
    _isLoading = true;
    notifyListeners();
    _sleep = await _userSleepService.getAllSleepByUserDates(
        userId, DateTime.now(), 1);
    _sleepHours = _sleep!.fold(Duration.zero, (a, b) => a + b.duration);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserSleepDate(String userId, DateTime date) async {
    _isLoading = true;
    notifyListeners();
    _sleep = await _userSleepService.getAllSleepByUserDates(userId, date, 1);
    _sleepHours = _sleep!.fold(Duration.zero, (a, b) => a + b.duration);
    _isLoading = false;
    notifyListeners();
  }

  Future<Duration> getUserLastNightSleep(String userId) async {
    var sleep = await _userSleepService.getAllSleepByUserDates(
        userId, DateTime.now(), 1);
    Duration duration = sleep.fold(Duration.zero, (a, b) => a + b.duration);
    return duration;
  }

  Future<void> fetchUser(String userId) async {
    _isLoading = true;
    notifyListeners();
    await fetchUserHeartRate(userId);
    await fetchUserSteps(userId);
    await fetchUserWater(userId);
    await fetchUserSleep(userId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addHeartRate(String userId, HeartRateData statistics) async {
    _isLoading = true;
    notifyListeners();
    await _userActivityService.addHeartRate(userId, statistics);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addSteps(String userId, StepData statistics) async {
    _isLoading = true;
    notifyListeners();
    await _userActivityService.addSteps(userId, statistics);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addWater(String userId, Water statistics) async {
    _isLoading = true;
    notifyListeners();
    await _userActivityService.addWaterData(userId, statistics);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addSleep(String userId, SleepData statistics) async {
    _isLoading = true;
    notifyListeners();
    await _userSleepService.addSleepData(userId, statistics);
    _isLoading = false;
    notifyListeners();
  }
}
