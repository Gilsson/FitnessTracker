import 'dart:convert';

import 'package:fitness_sync/application/converters/json_converter.dart';
import 'package:fitness_sync/domain/entities/data/calories_target.dart';

class ConvertCaloriesTarget implements JsonConverter<CaloriesTarget> {
  @override
  String encode(CaloriesTarget object) {
    return toJson(object);
  }

  @override
  CaloriesTarget decode(String json) {
    return fromJson(json);
  }

  String toJson(CaloriesTarget calories) {
    return jsonEncode({
      "date": calories.date.toIso8601String(),
      "calories": calories.calories,
      "userId": calories.userId,
      "id": calories.id
    });
  }

  CaloriesTarget fromJson(String text) {
    Map<String, dynamic> json = jsonDecode(text);
    if (json["date"] == null ||
        json["calories"] == null ||
        json["userId"] == null ||
        json["id"] == null) {
      throw FormatException("Invalid JSON format for CaloriesTarget");
    }
    var calories = CaloriesTarget.full(
        id: json["id"],
        userId: json["userId"],
        date: DateTime.parse(json["date"]),
        calories: json["calories"]);
    return calories;
  }
}
