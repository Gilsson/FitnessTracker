import 'package:fitness_sync/domain/entities/data/statistics.dart';
import 'package:fitness_sync/domain/entities/data/timed_data.dart';
import 'package:fitness_sync/domain/entities/entity.dart';
import 'package:fitness_sync/domain/entities/tasks/achievement.dart';
import 'package:fitness_sync/domain/entities/data/heart_rate.dart';
import 'package:fitness_sync/domain/entities/data/sleep_data.dart';
import 'package:fitness_sync/domain/entities/data/step_data.dart';

class UserDomain extends Entity {
  String name = "";
  String mail = "";
  String hashPassword = "";
  List<Achievement> achievements = [];
  List<StepData> stepData = [];
  List<SleepData> sleepData = [];
  List<HeartRateData> heartRateData = [];
  List<TimedData> userData = [];
  List<Statistics> statistics = [];
  UserDomain({required this.mail, required this.hashPassword});

  UserDomain.full(
      {String? id,
      required this.name,
      required this.mail,
      required this.achievements,
      required this.hashPassword,
      required this.heartRateData,
      required this.sleepData,
      required this.stepData,
      required this.userData,
      required this.statistics}) {
    if (id != null) {
      this.id = id;
    }
  }
}
