import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/data/exercise.dart';
import 'package:fitness_sync/domain/entities/data/workout.dart';

class WorkoutService {
  UnitOfWork unitOfWork;

  WorkoutService({required this.unitOfWork});

  Future<Workout> add(Workout workout) {
    return unitOfWork.workoutRepository.add(workout);
  }

  Future<Exercise?> addToWorkout(String workoutId, Exercise exercise) async {
    var workout = await unitOfWork.workoutRepository
        .getFirst([(workout) => workout.id == workoutId]);

    exercise = await unitOfWork.exerciseRepository.add(exercise);
    if (workout != null) {
      workout.addExercise(exercise);
      await unitOfWork.workoutRepository.update(workout);
      return exercise;
    }
    return null;
  }

  Future<Workout> updateWorkout(Workout workout) async {
    return unitOfWork.workoutRepository.update(workout);
  }

  Future<List<Workout>> getWorkouts() {
    return unitOfWork.workoutRepository.getAllList();
  }

  Future<Workout?> getById(String id) async {
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
        workout.removeExercise(exercise);
        await unitOfWork.workoutRepository.update(workout);
      }
    }
    return workout;
  }

  Future<DifficultyType> getOverallDifficulty(String workoutId) async {
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

  Future<Set<EquipmentType>> getAllUniqueEquipment(String workoutId) async {
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

  Future<List<Exercise>> getAllExercises(String workoutId) async {
    var workout = await getById(workoutId);
    if (workout != null) {
      return workout.exercises;
    }
    return [];
  }
}
