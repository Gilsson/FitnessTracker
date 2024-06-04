import 'package:fitness_lib/application/converters/sleep_converter.dart';
import 'package:fitness_sync/application/converters/calories_converter.dart';
import 'package:fitness_sync/application/converters/exercise_converter.dart';
import 'package:fitness_sync/application/converters/meal_converter.dart';
import 'package:fitness_sync/application/converters/sleep_converter.dart';
import 'package:fitness_sync/application/converters/convert_achievement.dart';
import 'package:fitness_sync/application/converters/convert_task.dart';
import 'package:fitness_sync/application/converters/heart_converter.dart';
import 'package:fitness_sync/application/converters/sleep_converter.dart';
import 'package:fitness_sync/application/converters/statistics_converter.dart';
import 'package:fitness_sync/application/converters/step_converter.dart';
import 'package:fitness_sync/application/converters/user_data_converter.dart';
import 'package:fitness_sync/application/converters/water_converter.dart';
import 'package:fitness_sync/application/converters/workout_converter.dart';
import 'package:fitness_sync/domain/entities/user/user_domain.dart';
import 'package:fitness_sync/application/converters/convert_user.dart';
import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/persistence/repository/firestore_repo.dart';

class FireBaseUnitOfWork extends UnitOfWork {
  static FireBaseUnitOfWork? instance;
  FireBaseUnitOfWork() {
    userRepository = FireStoreTemplateRepo<UserDomain>(
        collectionPath: "users",
        converter: ConvertUserService(
          achievementsService:
              ConvertAchievementsService(taskService: ConvertTaskService()),
          sleepService: ConvertSleepService(),
          stepService: ConvertStepService(),
          userDataService: ConvertUserDataService(),
          statisticsService: ConvertStatisticsService(),
          heartRateService: ConvertHeartService(),
        ));
    statisticsRepository = FireStoreTemplateRepo(
        converter: ConvertStatisticsService(), collectionPath: "statistics");
    sleepRepository = FireStoreTemplateRepo(
        converter: ConvertSleepService(), collectionPath: "sleep");
    stepDataRepository = FireStoreTemplateRepo(
        converter: ConvertStepService(), collectionPath: "steps");
    waterRepository = FireStoreTemplateRepo(
        converter: ConvertWaterService(), collectionPath: "water");
    heartRateRepository = FireStoreTemplateRepo(
        converter: ConvertHeartService(), collectionPath: "heartRate");

    mealRepository = FireStoreTemplateRepo(
        converter: ConvertMealService(), collectionPath: "meals");
    caloriesTargetRepository = FireStoreTemplateRepo(
        converter: ConvertCaloriesTarget(), collectionPath: "caloriesTarget");
    userExerciseRepository = FireStoreTemplateRepo(
        converter: ConvertUserExerciseService(),
        collectionPath: "userExercises");
    exerciseRepository = FireStoreTemplateRepo(
        converter: ConvertExerciseService(), collectionPath: "exercises");
    workoutRepository = FireStoreTemplateRepo(
        converter: ConvertWorkoutService(), collectionPath: "workouts");
    userWorkoutRepository = FireStoreTemplateRepo(
        converter: ConvertUserWorkoutService(), collectionPath: "userWorkouts");
    userMealRepository = FireStoreTemplateRepo(
        converter: ConvertUserMealService(), collectionPath: "userMeals");
  }

  static UnitOfWork getInstance() {
    if (instance == null) {
      instance = FireBaseUnitOfWork();
      return instance!;
    }
    return instance!;
  }

  @override
  void saveAllAsync() async {
    // TODO: Implement saveAllAsync
  }

  @override
  void deleteDataBaseAsync() async {
    // TODO: Implement deleteDataBaseAsync
  }

  @override
  void createDataBaseAsync() async {
    // TODO: Implement createDataBaseAsync
  }
}
