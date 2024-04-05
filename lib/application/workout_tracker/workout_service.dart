import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/data/exercise.dart';
import 'package:fitness_sync/domain/entities/data/workout.dart';

class WorkoutService {
  UnitOfWork unitOfWork;

  WorkoutService({required this.unitOfWork});

  Future<Workout> add(int userId, Workout workout) {
    workout.userId = userId;
    workout.duration = Duration.zero;
    for (var exercise in workout.exercises) {
      workout.duration += exercise.duration;
    }
    return unitOfWork.workoutRepository.add(workout);
  }

  Future<Exercise?> addToWorkout(int workoutId, Exercise exercise) async {
    var workout = await unitOfWork.workoutRepository
        .getFirst([(workout) => workout.id == workoutId]);
    if (workout != null) {
      workout.exercises.add(exercise);
      workout.duration += exercise.duration;
      await unitOfWork.workoutRepository.update(workout);
      return exercise;
    }
    return null;
  }

  Future<Workout> updateWorkout(Workout workout) async {
    workout.duration = Duration.zero;
    for (var exercise in workout.exercises) {
      workout.duration += exercise.duration;
    }
    return updateWorkout(workout);
  }

  Future<List<Workout>> getWorkouts(int userId) {
    return unitOfWork.workoutRepository
        .getAllListByParams([(workout) => workout.userId == userId]);
  }

  Future<Workout?> getById(int id) async {
    return unitOfWork.workoutRepository
        .getFirst([(workout) => workout.id == id]);
  }

  Future<Workout?> remove(int id) async {
    var workout = await unitOfWork.workoutRepository
        .getFirst([(workout) => workout.id == id]);
    if (workout != null) {
      unitOfWork.workoutRepository.remove(workout);
    }
    return workout;
  }

  Future<List<Workout>> getUncompletedWorkoutsByDate(
      int userId, DateTime start, DateTime end) {
    return unitOfWork.workoutRepository.getAllListByParams([
      (item) => item.userId == userId,
      (item) => !item.completed,
      (item) => item.date.isBefore(end),
      (item) => item.date.isAfter(start)
    ]);
  }

  Future<List<Workout>> getCompletedWorkoutsByDate(
      int userId, DateTime start, DateTime end) {
    return unitOfWork.workoutRepository.getAllListByParams([
      (item) => item.userId == userId,
      (item) => item.completed,
      (item) => item.date.isBefore(end),
      (item) => item.date.isAfter(start)
    ]);
  }

  Future<void> markWorkoutAsDone(int id) async {
    var workout = await getById(id);
    if (workout != null) {
      workout.completed = true;
      await updateWorkout(workout);
    }
  }

  Future<void> markExerciseAsDone(int workoutId, Exercise exercise) async {
    var workout = await getById(workoutId);
    if (workout != null) {
      workout.completed = true;
      await updateWorkout(workout);
    }
  }

  Future<Workout?> removeFromWorkout(int workoutId, int exerciseId) async {
    var workout = await unitOfWork.workoutRepository
        .getFirst([(workout) => workout.id == workoutId]);
    if (workout != null) {
      Exercise? exercise;
      try {
        exercise = workout.exercises
            .firstWhere((exercise) => exercise.id == exerciseId);
      } catch (e) {
        exercise = null;
      }
      if (exercise != null) {
        workout.exercises.remove(exercise);
        workout.duration -= exercise.duration;
        await unitOfWork.workoutRepository.update(workout);
      }
    }
    return workout;
  }

  Future<DifficultyType> getOverallDifficulty(int workoutId) async {
    var workout = await getById(workoutId);
    if (workout != null) {
      var max = DifficultyType.none;
      for (var exercise in workout.exercises) {
        if (exercise.difficulty.value > max.value) {
          max = exercise.difficulty;
        }
      }
      return max;
    }
    return DifficultyType.none;
  }

  Future<Set<EquipmentType>> getAllUniqueEquipment(int workoutId) async {
    var workout = await getById(workoutId);
    if (workout != null) {
      var set = <EquipmentType>{};
      for (var exercise in workout.exercises) {
        set.add(exercise.equipment);
      }
      return set;
    }
    return {};
  }

  Future<List<Exercise>> getAllExercises(int workoutId) async {
    var workout = await getById(workoutId);
    if (workout != null) {
      return workout.exercises;
    }
    return [];
  }
}
