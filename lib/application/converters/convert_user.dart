import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_sync/application/converters/convert_achievement.dart';
import 'package:fitness_sync/application/converters/heart_converter.dart';
import 'package:fitness_sync/application/converters/json_converter.dart';
import 'package:fitness_sync/application/converters/sleep_converter.dart';
import 'package:fitness_sync/application/converters/statistics_converter.dart';
import 'package:fitness_sync/application/converters/step_converter.dart';
import 'package:fitness_sync/application/converters/user_data_converter.dart';
import 'package:fitness_sync/domain/entities/data/heart_rate.dart';
import 'package:fitness_sync/domain/entities/data/sleep_data.dart';
import 'package:fitness_sync/domain/entities/data/statistics.dart';
import 'package:fitness_sync/domain/entities/data/step_data.dart';
import 'package:fitness_sync/domain/entities/data/timed_data.dart';
import 'package:fitness_sync/domain/entities/tasks/achievement.dart';
import 'package:fitness_sync/domain/entities/user/user_domain.dart';

class ConvertUserService implements JsonConverter<UserDomain> {
  final ConvertAchievementsService achievementsService;
  final ConvertHeartService heartRateService;
  final ConvertSleepService sleepService;
  final ConvertStepService stepService;
  final ConvertUserDataService userDataService;
  final ConvertStatisticsService statisticsService;
  ConvertUserService(
      {required this.achievementsService,
      required this.heartRateService,
      required this.sleepService,
      required this.stepService,
      required this.userDataService,
      required this.statisticsService});

  @override
  String encode(UserDomain user) {
    return toJson(user);
  }

  @override
  UserDomain decode(String json) {
    var user = fromJson(json);
    return user;
  }

  String toJson(UserDomain user) {
    return jsonEncode({
      "id": user.id,
      "name": user.name,
      "mail": user.mail,
      "hashPassword": user.hashPassword,
      "achievements": user.achievements
          .map((e) => jsonDecode(achievementsService.encode(e)))
          .toList(),
      "stepData":
          user.stepData.map((e) => jsonDecode(stepService.encode(e))).toList(),
      "sleepData": user.sleepData
          .map((e) => jsonDecode(sleepService.encode(e)))
          .toList(),
      "heartRateData": user.heartRateData
          .map((e) => jsonDecode(heartRateService.encode(e)))
          .toList(),
      "userData": user.userData
          .map((e) => jsonDecode(userDataService.encode(e)))
          .toList(),
      "statistics": user.statistics
          .map((e) => jsonDecode(statisticsService.encode(e)))
          .toList()
    });
  }

  UserDomain fromJson(String text) {
    Map<String, dynamic> json = jsonDecode(text);
    return UserDomain.full(
        id: json["id"],
        name: json["name"],
        mail: json["mail"],
        hashPassword: json["hashPassword"],
        achievements: List<Achievement>.from((json["achievements"] ?? [])
            .map((e) => achievementsService.decode(e))
            .toList()),
        heartRateData: List<HeartRateData>.from((json["heartRateData"] ?? [])
            .map((e) => heartRateService.decode(e))
            .toList()),
        sleepData: List<SleepData>.from((json["sleepData"] ?? [])
            .map((e) => sleepService.decode(e))
            .toList()),
        stepData: List<StepData>.from((json["stepData"] ?? [])
            .map((e) => stepService.decode(e))
            .toList()),
        userData: List<TimedData>.from((json["userData"] ?? [])
            .map((e) => userDataService.decode(e))
            .toList()),
        statistics: List<Statistics>.from(((json["userData"] ?? []) as List)
            .map((e) => statisticsService.decode(e))
            .toList()));
  }
}
