import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/data/exercise.dart';
import 'package:fitness_sync/domain/entities/data/workout.dart';

class UserWorkoutService {
  UnitOfWork unitOfWork;

  UserWorkoutService({required this.unitOfWork});

  Future<UserWorkout> add(String userId, UserWorkout workout) {
    workout.userId = userId;
    return unitOfWork.userWorkoutRepository.add(workout);
  }

  Future<UserWorkout> updateWorkout(UserWorkout workout) async {
    return unitOfWork.userWorkoutRepository.update(workout);
  }

  Future<List<UserWorkout>> getWorkouts(String userId) {
    return unitOfWork.userWorkoutRepository
        .getAllListByParams([(workout) => workout.userId == userId]);
  }

  Future<List<UserWorkout>> getInCompletedWorkouts(String userId) {
    return unitOfWork.userWorkoutRepository.getAllListByParams(
        [(workout) => workout.userId == userId && workout.completed == false]);
  }

  Future<List<UserWorkout>> getCompletedWorkouts(String userId) {
    return unitOfWork.userWorkoutRepository.getAllListByParams(
        [(workout) => workout.userId == userId && workout.completed == true]);
  }

  Future<UserWorkout?> getById(String id) async {
    return unitOfWork.userWorkoutRepository
        .getFirst([(workout) => workout.id == id]);
  }

  Future<UserWorkout?> remove(int id) async {
    var workout = await unitOfWork.userWorkoutRepository
        .getFirst([(workout) => workout.id == id]);
    if (workout != null) {
      unitOfWork.userWorkoutRepository.remove(workout);
    }
    return workout;
  }

  Future<List<UserWorkout>> getUncompletedWorkoutsByDate(
      String userId, DateTime start, DateTime end) {
    return unitOfWork.userWorkoutRepository.getAllListByParams([
      (item) => item.userId == userId,
      (item) => !item.completed,
      (item) => item.date.isBefore(end),
      (item) => item.date.isAfter(start)
    ]);
  }

  Future<List<UserWorkout>> getCompletedWorkoutsByDate(
      String userId, DateTime start, DateTime end) {
    return unitOfWork.userWorkoutRepository.getAllListByParams([
      (item) => item.userId == userId,
      (item) => item.completed,
      (item) => item.date.isBefore(end),
      (item) => item.date.isAfter(start)
    ]);
  }

  Future<void> markWorkoutAsDone(String id) async {
    var workout = await getById(id);
    if (workout != null) {
      workout.completed = true;
      await updateWorkout(workout);
    }
  }

  Future<void> markWorkoutAsNotDone(String id) async {
    var workout = await getById(id);
    if (workout != null) {
      workout.completed = false;
      await updateWorkout(workout);
    }
  }

  Future<void> markExerciseAsDone(String workoutId, Exercise exercise) async {
    var workout = await getById(workoutId);
    if (workout != null) {
      workout.completed = true;
      await updateWorkout(workout);
    }
  }

  Future<List<Workout>> getAll() {
    return unitOfWork.workoutRepository.getAllList();
  }
}
