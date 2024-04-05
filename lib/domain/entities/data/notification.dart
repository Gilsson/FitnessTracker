import 'package:fitness_sync/domain/entities/data/data.dart';

class Notification extends Data {
  String description = "";
  bool isViewed = false;
  String name;
  DateTime scheduledDate;
  late DateTime timeCreated;

  Notification(this.name, this.scheduledDate) {
    timeCreated = DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "isViewed": isViewed,
      "name": name,
      "scheduledDate": scheduledDate,
      "timeCreated": timeCreated
    };
  }
}
