import 'package:fitness_sync/domain/abstractions/repository.dart';
import 'package:fitness_sync/domain/entities/tasks/achievement.dart';
import 'package:fitness_sync/domain/entities/data/heart_rate.dart';
import 'package:fitness_sync/domain/entities/data/notification.dart';
import 'package:fitness_sync/domain/entities/data/sleep_data.dart';
import 'package:fitness_sync/domain/entities/data/statistics.dart';
import 'package:fitness_sync/domain/entities/data/step_data.dart';
import 'package:fitness_sync/domain/entities/data/timed_data.dart';
import 'package:fitness_sync/domain/entities/data/workout.dart';
import 'package:fitness_sync/domain/entities/meals/meals.dart';
import 'package:fitness_sync/domain/entities/user/user_domain.dart';
import 'package:fitness_sync/domain/entities/water/water.dart';

abstract class UnitOfWork {
  static UnitOfWork? instance;
  late Repository<UserDomain> userRepository;
  late Repository<Achievement> achievementRepository;
  late Repository<TimedData> dataRepository;
  late Repository<SleepData> sleepRepository;
  late Repository<Meals> mealRepository;
  late Repository<Statistics> statisticsRepository;
  late Repository<StepData> stepDataRepository;
  late Repository<HeartRateData> heartRateRepository;
  late Repository<Water> waterRepository;
  late Repository<Workout> workoutRepository;
  late Repository<Notification> notificationsRepository;

  void saveAllAsync();
  void deleteDataBaseAsync();
  void createDataBaseAsync();
}
