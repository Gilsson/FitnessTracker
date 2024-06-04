import 'dart:convert';

import 'package:fitness_sync/application/converters/json_converter.dart';
import 'package:fitness_sync/domain/entities/data/statistics.dart';

class ConvertStatisticsService implements JsonConverter<Statistics> {
  @override
  Statistics decode(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  String encode(Statistics object) {
    return jsonEncode(toMap(object));
  }

  Map<String, dynamic> toMap(Statistics statistics) {
    var map = statistics.toMap();
    map["type"] = statistics.type.index;
    map["time"] = statistics.time!.toIso8601String();
    map["value"] = statistics.value;
    return map;
  }

  Statistics fromMap(Map<String, dynamic> json) {
    return Statistics.full(
        type: StatisticsTypeExtension.fromValue(json["type"] as int),
        value: json["value"] as double,
        time: DateTime.parse(json["time"]),
        id: json["id"],
        userId: json["userId"]);
  }
}
