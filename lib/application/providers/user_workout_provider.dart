import 'package:fitness_sync/application/workout_tracker/user_workout_service.dart';
import 'package:fitness_sync/application/workout_tracker/workout_service.dart';
import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/data/workout.dart';
import 'package:flutter/material.dart';

class UserWorkoutProvider with ChangeNotifier {
  final UserWorkoutService _userWorkoutService;
  final WorkoutService _workoutService;

  UserWorkoutProvider(UnitOfWork unitOfWork)
      : _userWorkoutService = UserWorkoutService(unitOfWork: unitOfWork),
        _workoutService = WorkoutService(unitOfWork: unitOfWork);

  List<(Workout, UserWorkout)> _userWorkouts = [];
  List<(Workout, UserWorkout)> get userWorkouts => _userWorkouts;
  List<(Workout, UserWorkout)> _userCompletedWorkouts = [];
  List<(Workout, UserWorkout)> get userCompletedWorkouts =>
      _userCompletedWorkouts;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchUserWorkouts(String userId) async {
    _isLoading = true;
    notifyListeners();
    var userWorkouts = await _userWorkoutService.getInCompletedWorkouts(userId);
    _userWorkouts = [];
    for (var a in userWorkouts) {
      _userWorkouts.add(((await _workoutService.getById(a.workoutId))!, a));
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCompletedWorkouts(String userId) async {
    _isLoading = true;
    notifyListeners();
    var userWorkouts = await _userWorkoutService.getCompletedWorkouts(userId);
    _userCompletedWorkouts = [];
    for (var a in userWorkouts) {
      _userCompletedWorkouts
          .add(((await _workoutService.getById(a.workoutId))!, a));
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAsCompleted(UserWorkout workout) async {
    _isLoading = true;
    notifyListeners();
    await _userWorkoutService.markWorkoutAsDone(workout.id);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAsNotCompleted(UserWorkout workout) async {
    _isLoading = true;
    notifyListeners();
    await _userWorkoutService.markWorkoutAsNotDone(workout.id);
    _isLoading = false;
    notifyListeners();
  }

//   Future<void> fetchUserHeight(String userId) async {
//     _isLoading = true;
//     notifyListeners();
//     _height = await _userStatisticsService.getUserHeight(userId);
//     _isLoading = false;
//     notifyListeners();
//   }

//   Future<void> fetchBMI(String userId) async {
//     _isLoading = true;
//     notifyListeners();
//     _bmi = await _userStatisticsService.getBMI(userId);
//     _isLoading = false;
//     notifyListeners();
//   }

  Future<void> scheduleWorkout(
      String userId, Workout workout, DateTime timeScheduled) async {
    _isLoading = true;
    notifyListeners();
    await _userWorkoutService.add(
        userId,
        UserWorkout(
            workoutId: workout.id,
            completed: false,
            date: timeScheduled,
            isScheduled: true));
    fetchUserWorkouts(userId);
    _isLoading = false;
    notifyListeners();
  }

//   Future<void> updateStatistics(Statistics statistics) async {
//     _isLoading = true;
//     notifyListeners();
//     await _userStatisticsService.update(statistics);
//     _isLoading = false;
//     notifyListeners();
//   }

//   Future<void> removeStatistics(int id) async {
//     _isLoading = true;
//     notifyListeners();
//     await _userStatisticsService.remove(id);
//     _isLoading = false;
//     notifyListeners();
//   }
}
