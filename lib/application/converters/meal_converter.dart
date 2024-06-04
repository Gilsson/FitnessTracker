import 'dart:convert';
import 'package:fitness_sync/application/converters/json_converter.dart';
import 'package:fitness_sync/domain/entities/meals/meals.dart';

class ConvertMealService implements JsonConverter<Meals> {
  @override
  Meals decode(String json) {
    return fromJson(jsonDecode(json));
  }

  @override
  String encode(Meals object) {
    return jsonEncode(toJson(object));
  }

  Map<String, dynamic> toJson(Meals meal) {
    var map = {
      "id": meal.id,
      "name": meal.name,
      "nutrients": meal.nutrients.map((nutrient, value) {
        return MapEntry(nutrient.index.toString(), value.toString());
      }),
      "calories": meal.calories,
      "description": meal.description,
      "ingredients": meal.ingredients,
      "cookList": meal.cookList,
      "mealType": meal.mealType.index,
      "icon": meal.icon
    };
    return map;
  }

  Meals fromJson(Map<String, dynamic> json) {
    return Meals.full(
      id: json["id"],
      name: json["name"],
      nutrients: (json["nutrients"] as Map<String, dynamic>).map((key, value) =>
          MapEntry(
              NutrientsExtension.fromValue(int.parse(key)), int.parse(value))),
      calories: json["calories"],
      description: json["description"],
      ingredients: (json["ingredients"] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value as String)),
      cookList:
          (json["cookList"] as List<dynamic>).map((e) => e as String).toList(),
      mealType: MealTypeExtension.fromValue(json["mealType"]),
      icon: json["icon"],
    );
  }
}

class ConvertUserMealService implements JsonConverter<UserMeals> {
  @override
  UserMeals decode(String json) {
    return fromJson(jsonDecode(json));
  }

  @override
  String encode(UserMeals object) {
    return jsonEncode(toJson(object));
  }

  Map<String, dynamic> toJson(UserMeals meal) {
    var map = meal.toMap();
    map["meal"] = ConvertMealService().encode(meal.meal);
    map["date"] = meal.date.toIso8601String();
    map["isScheduled"] = meal.isScheduled;
    map["completed"] = meal.completed;

    return map;
  }

  UserMeals fromJson(Map<String, dynamic> json) {
    return UserMeals(
        id: json["id"],
        userId: json["userId"],
        meal: ConvertMealService().decode(json["meal"]),
        date: DateTime.parse(json["date"]),
        isScheduled: json["isScheduled"],
        completed: json["completed"]);
  }
}
