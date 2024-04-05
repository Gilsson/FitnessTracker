import 'package:fitness_sync/domain/entities/tasks/achievement.dart';
import 'package:fitness_sync/domain/entities/data/heart_rate.dart';
import 'package:fitness_sync/domain/entities/data/sleep_data.dart';
import 'package:fitness_sync/domain/entities/data/step_data.dart';

class MongoUserEntity {
  String name = "";
  String mail = "";
  String hashPassword = "";
  List<Achievement> achievements = [];
  List<StepData> stepData = [];
  List<SleepData> sleepData = [];
  List<HeartRateData> heartRateData = [];
}
