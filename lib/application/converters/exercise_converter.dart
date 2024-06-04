import 'dart:convert';

import 'package:fitness_sync/application/converters/json_converter.dart';
import 'package:fitness_sync/application/converters/parse_duration.dart';
import 'package:fitness_sync/domain/entities/data/exercise.dart';

class ConvertExerciseService implements JsonConverter<Exercise> {
  @override
  Exercise decode(String json) {
    return fromJson(jsonDecode(json));
  }

  @override
  String encode(Exercise object) {
    return jsonEncode(toJson(object));
  }

  Map<String, dynamic> toJson(Exercise exercise) {
    var map = exercise.toMap();
    map["name"] = exercise.name;
    map["description"] = exercise.description;
    map["category"] = exercise.category.index;
    map["equipment"] = exercise.equipment.index;
    map["difficulty"] = exercise.difficulty.index;
    map["guide"] = exercise.guide;
    map["sets"] = exercise.sets;
    map["reps"] = exercise.reps;
    map["calories"] = exercise.calories;
    map["duration"] = exercise.duration.toString();
    return map;
  }

  Exercise fromJson(Map<String, dynamic> json) {
    return Exercise.full(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      category: ExerciseCategoryExtension.fromValue(json["category"]),
      equipment: EquipmentTypeExtension.fromValue(json["equipment"]),
      difficulty: DifficultyTypeExtension.fromValue(json["difficulty"]),
      guide: (json["guide"] as List<dynamic>).map((e) => e as String).toList(),
      sets: json["sets"],
      reps: json["reps"],
      calories: json["calories"],
      duration: ParseDuration.parseDuration(json["duration"]),
    );
  }
}

class ConvertUserExerciseService implements JsonConverter<UserExercise> {
  @override
  UserExercise decode(String json) {
    return fromJson(jsonDecode(json));
  }

  @override
  String encode(UserExercise object) {
    return jsonEncode(toJson(object));
  }

  Map<String, dynamic> toJson(UserExercise exercise) {
    var map = exercise.toMap();
    map["exerciseId"] = exercise.exerciseId;
    map["completed"] = exercise.completed;
    map["date"] = exercise.date.toIso8601String();
    return map;
  }

  UserExercise fromJson(Map<String, dynamic> json) {
    return UserExercise.full(
      id: json["id"],
      userId: json["userId"],
      date: DateTime.parse(json["date"]),
      exerciseId: json["exerciseId"],
      completed: json["completed"],
    );
  }
}
