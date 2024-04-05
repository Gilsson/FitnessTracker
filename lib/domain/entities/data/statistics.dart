import 'package:fitness_sync/domain/entities/data/data.dart';

class Statistics extends Data {
  StatisticsType type;
  double value;
  late DateTime time;

  Statistics({required this.type, required this.value}) {
    time = DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {"type": type.customName, "userId": userId, "value": value};
  }
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
}
