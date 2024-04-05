import 'package:fitness_sync/domain/entities/data/exercise.dart';
import 'package:fitness_sync/domain/entities/data/timed_data.dart';

class Workout extends TimedData {
  List<Exercise> exercises = [];
  String name;
  String description = "";
  DifficultyType difficulty = DifficultyType.none;
  bool completed = false;
  Workout({required super.date, required super.duration, required this.name});

  @override
  Map<String, dynamic> toMap() {
    return {
      "date": date,
      "duration": duration,
      "exercises": exercises.map((e) => e.toMap()).toList(),
      "name": name,
      "description": description,
      "difficulty": difficulty.customName
    };
  }
}
