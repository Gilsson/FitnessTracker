import 'package:fitness_sync/application/converters/parse_duration.dart';
import 'package:fitness_sync/domain/entities/data/timed_data.dart';

class StepData extends TimedData {
  late int steps;
  StepData(
      {required this.steps,
      required super.date,
      required super.duration,
      bool? isScheduled}) {
    if (isScheduled != null) super.isScheduled = isScheduled;
  }
  StepData.withUser(
      {required userId,
      required this.steps,
      required DateTime date,
      required Duration duration,
      required String id,
      required bool isScheduled})
      : super.full(
            userId: userId,
            id: id,
            date: date,
            duration: duration,
            isScheduled: isScheduled);

  @override
  factory StepData.fromMap(Map<String, dynamic> map) {
    return StepData.withUser(
        userId: map["userId"],
        steps: map["steps"],
        date: DateTime.parse(map["dateMeasured"]),
        duration: ParseDuration.parseDuration(map["timeDuration"]),
        id: map["id"],
        isScheduled: map["isScheduled"]);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map["steps"] = steps;
    return map;
  }
}
