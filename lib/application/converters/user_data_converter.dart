import 'dart:convert';

import 'package:fitness_sync/application/converters/json_converter.dart';
import 'package:fitness_sync/domain/entities/data/timed_data.dart';

class ConvertUserDataService implements JsonConverter<TimedData> {
  @override
  TimedData decode(String json) {
    return fromJson(jsonDecode(json));
  }

  @override
  String encode(TimedData timedData) {
    return jsonEncode(toJson(timedData));
  }

  Map<String, dynamic> toJson(TimedData timedData) {
    return timedData.toMap();
  }

  TimedData fromJson(Map<String, dynamic> json) {
    return TimedData.fromMap(json);
  }
}
