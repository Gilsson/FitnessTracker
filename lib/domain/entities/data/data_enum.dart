enum DataType { sleep, heartRate, steps, weight, height, age, sex, none }

extension DataTypeExtension on DataType {
  String get customName {
    switch (this) {
      case DataType.sleep:
        return "Sleep";
      case DataType.heartRate:
        return "Heart Rate";
      case DataType.steps:
        return "Steps";
      case DataType.weight:
        return "Weight";
      case DataType.height:
        return "Height";
      case DataType.age:
        return "Age";
      case DataType.sex:
        return "Sex";
      case DataType.none:
        return "None";
    }
  }
}
