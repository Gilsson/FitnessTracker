import 'dart:core';

import 'package:fitness_sync/domain/Entities/entity.dart';
import 'package:fitness_sync/domain/entities/data/achievement.dart';
import 'package:fitness_sync/domain/entities/data/heart_rate.dart';
import 'package:fitness_sync/domain/entities/data/sleep_data.dart';
import 'package:fitness_sync/domain/entities/data/step_data.dart';

class MockUserEntity extends Entity {
  String name = "";
  String mail = "";
  String password = "";
  List<Achievement> achievements = [];
  List<StepData> stepData = [];
  List<SleepData> sleepData = [];
  List<HeartRateData> heartRateData = [];
}
