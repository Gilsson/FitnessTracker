import 'package:fitness_sync/domain/entities/data/data.dart';

class Water extends Data {
  int amount;

  DateTime dateTaken;
  bool isScheduled = false;

  Water({required this.amount, required this.dateTaken, bool? isScheduled}) {
    if (isScheduled != null) {
      this.isScheduled = isScheduled;
    }
  }
  Water.full(
      {required this.amount,
      required this.dateTaken,
      required id,
      required userId,
      bool? isScheduled})
      : super.withId(userId: userId, id: id) {
    if (isScheduled != null) {
      this.isScheduled = isScheduled;
    }
  }
}
