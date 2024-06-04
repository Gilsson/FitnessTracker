import 'package:fitness_sync/domain/entities/data/timed_data.dart';

class SleepData extends TimedData {
  SleepStage sleepStage = SleepStage.none;

  SleepData(
      {required super.date,
      required super.duration,
      required this.sleepStage}) {
    if (sleepStage == SleepStage.planned) {
      isScheduled = true;
    }
  }
  SleepData.full(
      {required DateTime date,
      required Duration duration,
      required this.sleepStage,
      required String userId,
      required String id,
      bool? isScheduled})
      : super.full(
            userId: userId,
            id: id,
            date: date,
            duration: duration,
            isScheduled: isScheduled ?? false) {
    if (isScheduled != null) {
      if (isScheduled) sleepStage = SleepStage.planned;
    }
  }
  @override
  Map<String, dynamic> toMap() {
    return {
      "date": date,
      "duration": duration,
      "userId": userId,
      "sleepStage": sleepStage.customName,
      "isScheduled": isScheduled
    };
  }
}

enum SleepStage { awake, light, deep, rem, planned, none }

extension SleepStageExtension on SleepStage {
  String get customName {
    switch (this) {
      case SleepStage.awake:
        return "Awake";
      case SleepStage.light:
        return "Light";
      case SleepStage.deep:
        return "Deep";
      case SleepStage.rem:
        return "Rem";
      case SleepStage.planned:
        return "Planned";
      case SleepStage.none:
        return "None";
    }
  }

  static SleepStage fromValue(int value) {
    switch (value) {
      case 0:
        return SleepStage.awake;
      case 1:
        return SleepStage.light;
      case 2:
        return SleepStage.deep;
      case 3:
        return SleepStage.rem;
      default:
        return SleepStage.none;
    }
  }
}
