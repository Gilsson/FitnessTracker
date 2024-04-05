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
  UserDomain({required this.mail, required this.hashPassword});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "mail": mail,
      "hashPassword": hashPassword,
      "achievements": achievements.map((e) => e.toMap()).toList(),
      "stepData": stepData.map((e) => e.toMap()).toList(),
      "sleepData": sleepData.map((e) => e.toMap()).toList(),
      "heartRateData": heartRateData.map((e) => e.toMap()).toList(),
      "userData": userData.map((e) => e.toMap()).toList(),
    };
  }
}
