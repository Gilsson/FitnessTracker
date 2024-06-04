import 'dart:convert';

import 'package:fitness_sync/application/converters/json_converter.dart';
import 'package:fitness_sync/application/converters/parse_duration.dart';
import 'package:fitness_sync/domain/entities/data/heart_rate.dart';

class ConvertHeartService implements JsonConverter<HeartRateData> {
  @override
  HeartRateData decode(String jsonString) {
    return fromJson(jsonString);
  }

  @override
  String encode(HeartRateData heartData) {
    return toJson(heartData);
  }

  HeartRateData fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return HeartRateData.full(
        id: json["id"],
        userId: json["userId"],
        date: DateTime.parse(json["date"]),
        rate: json["rate"],
        duration: ParseDuration.parseDuration(json["duration"]),
        isScheduled: json["isScheduled"]);
  }

  String toJson(HeartRateData heartData) {
    return jsonEncode(heartData.toMap());
  }
}
