import 'dart:convert';

import 'package:fitness_sync/application/converters/json_converter.dart';
import 'package:fitness_sync/application/converters/parse_duration.dart';
import 'package:fitness_sync/domain/entities/data/step_data.dart';

class ConvertStepService implements JsonConverter<StepData> {
  @override
  StepData decode(String json) {
    return fromJson(jsonDecode(json));
  }

  @override
  String encode(StepData stepData) {
    return jsonEncode(toJson(stepData));
  }

  StepData fromJson(Map<String, dynamic> json) {
    var data = StepData.withUser(
      id: json['id'],
      userId: json['userId'],
      steps: json['steps'],
      date: DateTime.parse(json['date']),
      duration: ParseDuration.parseDuration(json['duration']),
      isScheduled: json['isScheduled'],
    );
    return data;
  }

  Map<String, dynamic> toJson(StepData stepData) {
    return stepData.toMap();
    // return {
    //   'steps': stepData.steps,
    //   'dateMeasured': stepData.date.toIso8601String(),
    //   'timeDuration': stepData.duration.toString(),
    // };
  }
}
