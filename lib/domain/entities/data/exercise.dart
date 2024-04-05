import 'package:fitness_sync/domain/entities/data/timed_data.dart';

class Exercise extends TimedData {
  String name;
  String description = "";
  ExerciseCategory category;
  EquipmentType equipment;
  DifficultyType difficulty;
  List<String> guide = [];
  int sets;
  int reps;
  int calories;
  bool completed = false;
  DateTime timeCompleted = DateTime.utc(0);

  Exercise({
    required this.name,
    required this.category,
    required this.equipment,
    required this.difficulty,
    required this.sets,
    required this.reps,
    required this.calories,
    required super.date,
    required super.duration,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "category": category.customName,
      "equipment": equipment.customName,
      "difficulty": difficulty.customName,
      "guide": guide,
      "sets": sets,
      "reps": reps,
      "calories": calories
    };
  }
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
