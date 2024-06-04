import 'dart:convert';

import 'package:fitness_sync/application/converters/json_converter.dart';
import 'package:fitness_sync/application/converters/parse_duration.dart';
import 'package:fitness_sync/domain/entities/data/sleep_data.dart';

class ConvertSleepService implements JsonConverter<SleepData> {
  @override
  SleepData decode(String json) {
    return fromJson(json);
  }

  @override
  String encode(SleepData object) {
    return jsonEncode(toJson(object));
  }

  SleepData fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return SleepData.full(
      date: DateTime.parse(jsonMap['date']),
      duration: ParseDuration.parseDuration(jsonMap['duration']),
      sleepStage: SleepStageExtension.fromValue(jsonMap['sleepStage']),
      id: jsonMap['id'],
      userId: jsonMap['userId'],
      isScheduled: jsonMap['isScheduled'],
    );
  }

  Map<String, dynamic> toJson(SleepData sleepData) {
    Map<String, dynamic> jsonMap = {
      'date': sleepData.date.toIso8601String(),
      'duration': sleepData.duration.toString(),
      'sleepStage': sleepData.sleepStage.index,
      'id': sleepData.id,
      'userId': sleepData.userId,
      'isScheduled': sleepData.isScheduled
    };
    return jsonMap;
  }
}
