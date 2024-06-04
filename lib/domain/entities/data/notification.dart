import 'package:fitness_sync/domain/entities/data/data.dart';

class Notification extends Data {
  String description = "";
  bool isViewed = false;
  String name;
  late DateTime timeCreated;

  Notification(this.name) {
    timeCreated = DateTime.now();
  }

  Notification.full(
      {required this.description,
      required this.isViewed,
      required this.name,
      required this.timeCreated});

  Notification.withId(
      {required this.description,
      required this.isViewed,
      required this.name,
      required this.timeCreated,
      required id,
      required userId})
      : super.withId(userId: userId, id: id);
}
