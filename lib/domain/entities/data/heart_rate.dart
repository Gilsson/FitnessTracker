import 'package:fitness_sync/domain/entities/data/timed_data.dart';

class HeartRateData extends TimedData {
  int rate;

  HeartRateData({
    required super.date,
    required this.rate,
    required super.duration,
  });
}
