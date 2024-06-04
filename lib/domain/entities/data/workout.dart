import 'package:fitness_sync/domain/entities/data/data.dart';
import 'package:fitness_sync/domain/entities/data/exercise.dart';
import 'package:fitness_sync/domain/entities/data/timed_data.dart';
import 'package:fitness_sync/domain/entities/entity.dart';

class Workout extends Entity {
  List<Exercise> exercises = [];
  String name;
  String description = "";
  DifficultyType difficulty = DifficultyType.none;
  Duration _duration;
  Duration get duration => _duration;
  Workout({required this.name, required this.exercises})
      : _duration = exercises.fold(Duration.zero, (a, b) => a + b.duration);
  Workout.full(
      {required this.name,
      required this.exercises,
      required this.description,
      required this.difficulty,
      required String id})
      : _duration = exercises.fold(Duration.zero, (a, b) => a + b.duration),
        super.withId(id);
  Exercise addExercise(Exercise exercise) {
    exercises.add(exercise);
    _duration = exercises.fold(Duration.zero, (a, b) => a + b.duration);
    return exercise;
  }

  int getCalories() {
    return exercises.fold(0, (a, b) => a + b.calories);
  }

  Exercise removeExercise(Exercise exercise) {
    exercises.remove(exercise);
    _duration = exercises.fold(Duration.zero, (a, b) => a + b.duration);
    return exercise;
  }
}

class UserWorkout extends Data {
  String workoutId;

  bool completed = false;
  bool isScheduled = false;
  DateTime date;
  UserWorkout.full(
      {required this.workoutId,
      required this.completed,
      required String id,
      required String userId,
      required this.date,
      required this.isScheduled})
      : super.withId(userId: userId, id: id);
  UserWorkout(
      {required this.workoutId,
      required this.completed,
      required this.date,
      required this.isScheduled});
}
