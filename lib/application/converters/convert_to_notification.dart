import 'package:fitness_sync/domain/entities/data/notification.dart';

class ConvertToNotificationService {
  Notification toNotification(Map<String, dynamic> map) {
    return Notification.full(
        description: map.containsKey("description") ? map["description"] : "",
        isViewed: false,
        name: map.containsKey("name") ? map["name"] : "",
        timeCreated: DateTime.parse(map["date"]));
  }
}
