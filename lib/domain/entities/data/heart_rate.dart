import 'package:fitness_sync/domain/entities/data/timed_data.dart';

class HeartRateData extends TimedData {
  int rate;

  HeartRateData({
    required super.date,
    required this.rate,
    required super.duration,
  });

  HeartRateData.full(
      {required DateTime date,
      required this.rate,
      required Duration duration,
      required String userId,
      required String id,
      required bool isScheduled})
      : super.full(
            userId: userId,
            id: id,
            date: date,
            duration: duration,
            isScheduled: isScheduled);

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["rate"] = rate;
    return map;
  }
}
