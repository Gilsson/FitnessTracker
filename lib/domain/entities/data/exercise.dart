import 'package:fitness_sync/domain/entities/data/data.dart';
import 'package:fitness_sync/domain/entities/data/timed_data.dart';
import 'package:fitness_sync/domain/entities/entity.dart';

class Exercise extends Entity {
  String name;
  String description = "";
  ExerciseCategory category;
  EquipmentType equipment;
  DifficultyType difficulty;
  List<String> guide = [];
  int sets;
  int reps;
  int calories;
  Duration duration = Duration(seconds: 0);

  Exercise({
    required this.name,
    required this.category,
    required this.equipment,
    required this.difficulty,
    required this.sets,
    required this.reps,
    required this.calories,
    required this.duration,
    this.guide = const [],
  });
  Exercise.full({
    required this.name,
    required this.category,
    required this.equipment,
    required this.difficulty,
    required this.sets,
    required this.reps,
    required this.calories,
    required this.description,
    required this.guide,
    required this.duration,
    required String id,
  }) : super.withId(id);
}

enum ExerciseCategory { cardivascular, strength, flexibility, none }

extension ExerciseCategoryExtension on ExerciseCategory {
  String get customName {
    switch (this) {
      case ExerciseCategory.cardivascular:
        return "Cardivascular";
      case ExerciseCategory.strength:
        return "Strength";
      case ExerciseCategory.flexibility:
        return "Flexibility";
      case ExerciseCategory.none:
        return "None";
    }
  }

  static ExerciseCategory fromValue(int value) {
    switch (value) {
      case 0:
        return ExerciseCategory.cardivascular;
      case 1:
        return ExerciseCategory.strength;
      case 2:
        return ExerciseCategory.flexibility;
      default:
        return ExerciseCategory.none;
    }
  }
}

enum EquipmentType {
  none,
  treadmill,
  barbell,
  elliptical,
  bike,
  pullupBar,
  dumbbell,
  kettlebell,
  bodyweight,
  custom
}

extension EquipmentTypeExtension on EquipmentType {
  String get customName {
    switch (this) {
      case EquipmentType.none:
        return "None";
      case EquipmentType.treadmill:
        return "Treadmill";
      case EquipmentType.barbell:
        return "Barbell";
      case EquipmentType.elliptical:
        return "Elliptical";
      case EquipmentType.bike:
        return "Bike";
      case EquipmentType.pullupBar:
        return "Pullup Bar";
      case EquipmentType.dumbbell:
        return "Dumbbell";
      case EquipmentType.kettlebell:
        return "Kettlebell";
      case EquipmentType.bodyweight:
        return "Bodyweight";
      case EquipmentType.custom:
        return "Custom";
    }
  }

  static EquipmentType fromValue(int value) {
    switch (value) {
      case 0:
        return EquipmentType.none;
      case 1:
        return EquipmentType.treadmill;
      case 2:
        return EquipmentType.barbell;
      case 3:
        return EquipmentType.elliptical;
      case 4:
        return EquipmentType.bike;
      case 5:
        return EquipmentType.pullupBar;
      case 6:
        return EquipmentType.dumbbell;
      case 7:
        return EquipmentType.kettlebell;
      case 8:
        return EquipmentType.bodyweight;
      case 9:
        return EquipmentType.custom;
      default:
        return EquipmentType.none;
    }
  }
}

enum DifficultyType { easy, medium, hard, none }

extension DifficultyTypeExtension on DifficultyType {
  String get customName {
    switch (this) {
      case DifficultyType.easy:
        return "Easy";
      case DifficultyType.medium:
        return "Medium";
      case DifficultyType.hard:
        return "Hard";
      case DifficultyType.none:
        return "None";
    }
  }

  int get value {
    switch (this) {
      case DifficultyType.easy:
        return 1;
      case DifficultyType.medium:
        return 2;
      case DifficultyType.hard:
        return 3;
      case DifficultyType.none:
        return 0;
    }
  }

  static DifficultyType fromValue(int value) {
    switch (value) {
      case 1:
        return DifficultyType.easy;
      case 2:
        return DifficultyType.medium;
      case 3:
        return DifficultyType.hard;
      default:
        return DifficultyType.none;
    }
  }
}

class UserExercise extends Data {
  String exerciseId;
  bool completed = false;
  DateTime date;
  UserExercise({required this.date, required this.exerciseId});
  UserExercise.full(
      {required String id,
      required String userId,
      required this.date,
      required this.exerciseId,
      required this.completed})
      : super.withId(userId: userId, id: id);
}
