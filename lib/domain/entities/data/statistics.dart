import 'package:fitness_sync/domain/entities/data/data.dart';

class Statistics extends Data {
  StatisticsType type;
  double value;
  DateTime? time;

  Statistics({required this.type, required this.value}) {
    time = DateTime.now();
  }

  Statistics.withId(
      {required this.type, required this.value, required String userId})
      : super.userId(userId: userId) {
    time = DateTime.now();
  }

  Statistics.full(
      {required this.type,
      required this.value,
      required this.time,
      required id,
      required userId})
      : super.withId(userId: userId, id: id);
}

enum StatisticsType { height, weight, age, sex, none }

extension StatisticsTypeExtension on StatisticsType {
  String get customName {
    switch (this) {
      case StatisticsType.height:
        return "Height";
      case StatisticsType.weight:
        return "Weight";
      case StatisticsType.age:
        return "Age";
      case StatisticsType.sex:
        return "Sex";
      case StatisticsType.none:
        return "None";
    }
  }

  static StatisticsType fromValue(int value) {
    switch (value) {
      case 0:
        return StatisticsType.height;
      case 1:
        return StatisticsType.weight;
      case 2:
        return StatisticsType.age;
      case 3:
        return StatisticsType.sex;
      default:
        return StatisticsType.none;
    }
  }
}
