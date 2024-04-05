import 'package:fitness_sync/domain/entities/entity.dart';

class Meals extends Entity {
  String name = "";
  int userId = 0;
  Map<String, int> nutrients = {};
  int calories = 0;
  String description = "";
  Map<String, String> ingredients = {};
  List<String> cookList = [];
  MealType mealType = MealType.none;
  DateTime timeTaken = DateTime.now();
  bool isCompleted = false;
  Meals(
      {required this.name,
      required this.mealType,
      required this.timeTaken,
      required this.nutrients,
      required this.calories});
  Meals.empty();

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "nutrients": nutrients,
      "calories": calories,
      "description": description,
      "ingredients": ingredients,
      "cookList": cookList,
      "mealType": mealType.customName,
      "timeTaken": timeTaken
    };
  }
}

enum MealType { breakfast, lunch, dinner, snacks, none }

extension MealTypeExtension on MealType {
  String get customName {
    switch (this) {
      case MealType.breakfast:
        return "Breakfast";
      case MealType.lunch:
        return "Lunch";
      case MealType.dinner:
        return "Dinner";
      case MealType.snacks:
        return "Snacks";
      case MealType.none:
        return "None";
    }
  }
}
