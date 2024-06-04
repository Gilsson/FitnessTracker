import 'package:fitness_sync/application/converters/parse_duration.dart';
import 'package:fitness_sync/domain/entities/data/data.dart';

class TimedData extends Data {
  late DateTime _date;
  late Duration _duration;

  bool isScheduled = false;
  DateTime get date => _date;
  Duration get duration => _duration;
  TimedData({
    required DateTime date,
    required Duration duration,
  }) : super.withId(userId: "0", id: "0") {
    _date = date;
    _duration = duration;
  }

  TimedData.full(
      {required userId,
      required id,
      required date,
      required duration,
      required this.isScheduled})
      : super.withId(userId: userId, id: id) {
    _date = date;
    _duration = duration;
  }

  factory TimedData.fromMap(Map<String, dynamic> map) {
    return TimedData.full(
      userId: map["userId"],
      id: map["id"],
      date: DateTime.parse(map["date"]),
      duration: ParseDuration.parseDuration(map["duration"]),
      isScheduled: map["isScheduled"],
    );
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["date"] = _date.toIso8601String();
    map["duration"] = _duration.toString();
    map["isScheduled"] = isScheduled;
    return map;
  }

  set date(DateTime value) {
    _date = value;
  }

  set duration(Duration value) {
    _duration = value;
  }
}
