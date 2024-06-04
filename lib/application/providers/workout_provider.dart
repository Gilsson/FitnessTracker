import 'package:fitness_sync/application/workout_tracker/workout_service.dart';
import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/data/exercise.dart';
import 'package:fitness_sync/domain/entities/data/workout.dart';
import 'package:flutter/material.dart';
import 'package:fitness_sync/domain/entities/data/statistics.dart';

class WorkoutProvider with ChangeNotifier {
  final WorkoutService _workoutService;

  WorkoutProvider(UnitOfWork unitOfWork)
      : _workoutService = WorkoutService(unitOfWork: unitOfWork);

  List<Workout> _allWorkouts = [];
  List<Workout> get allWorkouts => _allWorkouts;
  Workout? _selectedWorkout;
  Workout? get selectedWorkout => _selectedWorkout;
  Set<EquipmentType> _equipment = Set();
  Set<EquipmentType> get equipment => _equipment;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchAllWorkouts() async {
    _isLoading = true;
    notifyListeners();
    _allWorkouts = await _workoutService.getWorkouts();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeWorkout(int id) async {
    _isLoading = true;
    notifyListeners();
    await _workoutService.remove(id);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addWorkout(Workout workout) async {
    _isLoading = true;
    notifyListeners();
    var exercises = List.from(workout.exercises);
    workout.exercises.clear();
    await _workoutService.add(workout);
    for (var exercise in exercises) {
      await _workoutService.addToWorkout(workout.id, exercise);
    }
    _isLoading = false;
    _equipment = await _workoutService.getAllUniqueEquipment(workout.id);
    notifyListeners();
  }

  Future<Set<EquipmentType>> getAllUniqueEquipment(String workoutId) async {
    _equipment = await _workoutService.getAllUniqueEquipment(workoutId);
    notifyListeners();
    return _equipment;
  }

  Future<void> addExerciseToWorkout(String workoutId, Exercise exercise) async {
    _isLoading = true;
    notifyListeners();
    await _workoutService.addToWorkout(workoutId, exercise);
    await fetchAllWorkouts();
    _isLoading = false;
    notifyListeners();
  }
}
