import 'package:fitness_sync/domain/entities/data/data.dart';

abstract class TimedData extends Data {
  late DateTime _date;
  late Duration _duration;

  DateTime get date => _date;
  Duration get duration => _duration;
  TimedData({
    required DateTime date,
    required Duration duration,
  }) {
    _date = date;
    _duration = duration;
  }
  set date(DateTime value) {
    _date = value;
  }

  set duration(Duration value) {
    _duration = value;
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "dateMeasured": date,
      "timeDuration": duration,
    };
  }
}
