import 'package:fitness_sync/domain/entities/data/data.dart';
import 'package:fitness_sync/domain/entities/entity.dart';

class Meals extends Entity {
  String name = "";
  Map<Nutrients, int> nutrients = {};
  int calories = 0;
  String description = "";
  Map<String, String> ingredients = {};
  List<String> cookList = [];
  MealType mealType = MealType.none;
  String icon = "";
  Meals.scheduled({required this.calories}) {}
  Meals({
    required this.name,
    required this.mealType,
    required this.nutrients,
    required this.calories,
  });
  Meals.empty();

  Meals.full({
    required this.name,
    required this.mealType,
    required this.nutrients,
    required this.calories,
    required this.description,
    required this.ingredients,
    required this.cookList,
    required this.icon,
    required String id,
  }) : super.withId(id);
}

enum Nutrients {
  carbohydrates, //
  proteins, //
  fats, //
  vitamins, //
  minerals, //
  fibre, //
  water //
}

extension NutrientsExtension on Nutrients {
  String get customName {
    switch (this) {
      case Nutrients.carbohydrates:
        return "Carbohydrates";
      case Nutrients.proteins:
        return "Proteins";
      case Nutrients.fats:
        return "Fats";
      case Nutrients.vitamins:
        return "Vitamins";
      case Nutrients.minerals:
        return "Minerals";
      case Nutrients.fibre:
        return "Fibre";
      case Nutrients.water:
        return "Water";
    }
  }

  static Nutrients fromValue(int value) {
    switch (value) {
      case 0:
        return Nutrients.carbohydrates;
      case 1:
        return Nutrients.proteins;
      case 2:
        return Nutrients.fats;
      case 3:
        return Nutrients.vitamins;
      case 4:
        return Nutrients.minerals;
      case 5:
        return Nutrients.fibre;
      case 6:
        return Nutrients.water;
      default:
        return Nutrients.carbohydrates;
    }
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

  static MealType fromValue(int value) {
    switch (value) {
      case 0:
        return MealType.breakfast;
      case 1:
        return MealType.lunch;
      case 2:
        return MealType.dinner;
      case 3:
        return MealType.snacks;
      default:
        return MealType.none;
    }
  }
}

class UserMeals extends Data {
  Meals meal;

  bool completed = false;
  bool isScheduled = false;
  DateTime date;
  UserMeals(
      {required id,
      required userId,
      required this.meal,
      required this.date,
      required this.completed,
      required this.isScheduled})
      : super.withId(userId: userId, id: id);
  UserMeals.part(
      {required this.meal,
      required this.date,
      required this.completed,
      required this.isScheduled});
}
