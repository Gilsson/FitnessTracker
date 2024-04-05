import 'package:fitness_sync/domain/entities/data/timed_data.dart';

class StepData extends TimedData {
  late int steps;
  StepData({required this.steps, required super.date, required super.duration});

  @override
  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "dateMeasured": date,
      "timeDuration": duration,
      "steps": steps
    };
  }
}
