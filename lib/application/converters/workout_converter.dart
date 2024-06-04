import 'dart:convert';

import 'package:fitness_sync/application/converters/exercise_converter.dart';
import 'package:fitness_sync/application/converters/json_converter.dart';
import 'package:fitness_sync/domain/entities/data/exercise.dart';
import 'package:fitness_sync/domain/entities/data/workout.dart';

class ConvertWorkoutService implements JsonConverter<Workout> {
  @override
  Workout decode(String json) {
    return toJson(jsonDecode(json));
  }

  @override
  String encode(Workout object) {
    return jsonEncode(toMap(object));
  }

  Workout toJson(Map<String, dynamic> json) {
    return Workout.full(
      exercises: (json["exercises"] as List<dynamic>)
          .map((e) => ConvertExerciseService().decode(e))
          .toList(),
      name: json["name"],
      description: json["description"],
      difficulty: DifficultyTypeExtension.fromValue(json["difficulty"]),
      id: json["id"],
    );
  }

  Map<String, dynamic> toMap(Workout workout) {
    var map = workout.toMap();
    map["exercises"] = workout.exercises
        .map((e) => ConvertExerciseService().encode(e))
        .toList();
    map["name"] = workout.name;
    map["description"] = workout.description;
    map["difficulty"] = workout.difficulty.index;
    return map;
  }
}

class ConvertUserWorkoutService implements JsonConverter<UserWorkout> {
  @override
  UserWorkout decode(String json) {
    return toJson(jsonDecode(json));
  }

  @override
  String encode(UserWorkout object) {
    return jsonEncode(toMap(object));
  }

  UserWorkout toJson(Map<String, dynamic> json) {
    return UserWorkout.full(
      id: json["id"],
      userId: json["userId"],
      date: DateTime.parse(json["date"]),
      workoutId: json["workoutId"],
      isScheduled: json["isScheduled"],
      completed: json["completed"],
    );
  }

  Map<String, dynamic> toMap(UserWorkout workout) {
    var map = workout.toMap();
    map["workoutId"] = workout.workoutId;
    map["completed"] = workout.completed;
    map["date"] = workout.date.toIso8601String();
    map["isScheduled"] = workout.isScheduled;
    return map;
  }
}
