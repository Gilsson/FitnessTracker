import 'package:fitness_sync/application/user/user_statistics_service.dart';
import 'package:fitness_sync/domain/entities/data/heart_rate.dart';
import 'package:flutter/material.dart';
import 'package:fitness_sync/domain/entities/data/statistics.dart';
import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';

class UserStatisticsProvider with ChangeNotifier {
  final UserStatisticsService _userStatisticsService;

  UserStatisticsProvider(UnitOfWork unitOfWork)
      : _userStatisticsService = UserStatisticsService(unitOfWork: unitOfWork);

  Statistics? _weight;
  Statistics? get weight => _weight;

  Statistics? _height;
  Statistics? get height => _height;

  double? _bmi;
  double? get bmi => _bmi;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchUserWeight(String userId) async {
    _isLoading = true;
    notifyListeners();
    _weight = await _userStatisticsService.getUserWeight(userId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserHeight(String userId) async {
    _isLoading = true;
    notifyListeners();
    _height = await _userStatisticsService.getUserHeight(userId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchBMI(String userId) async {
    _isLoading = true;
    notifyListeners();
    _bmi = await _userStatisticsService.getBMI(userId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addStatistics(String userId, Statistics statistics) async {
    _isLoading = true;
    notifyListeners();
    await _userStatisticsService.addStatistics(userId, statistics);
    await fetchUserWeight(userId); // Fetch updated data
    await fetchUserHeight(userId);
    await fetchBMI(userId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateStatistics(Statistics statistics) async {
    _isLoading = true;
    notifyListeners();
    await _userStatisticsService.update(statistics);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeStatistics(int id) async {
    _isLoading = true;
    notifyListeners();
    await _userStatisticsService.remove(id);
    _isLoading = false;
    notifyListeners();
  }
}
