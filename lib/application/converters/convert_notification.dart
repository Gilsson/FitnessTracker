import 'dart:convert';

import 'package:fitness_sync/application/converters/json_converter.dart';
import 'package:fitness_sync/domain/entities/data/notification.dart';

class ConvertNotificationService implements JsonConverter<Notification> {
  @override
  Notification decode(String json) {
    return fromJson(jsonDecode(json));
  }

  @override
  String encode(Notification object) {
    return jsonEncode(toJson(object));
  }

  Notification fromJson(Map<String, dynamic> json) {
    return Notification.withId(
        description: json["description"],
        isViewed: json["isViewed"],
        name: json["name"],
        timeCreated: DateTime.parse(json["timeCreated"]),
        id: json["id"],
        userId: json["userId"]);
  }

  Map<String, dynamic> toJson(Notification notification) {
    return {
      "description": notification.description,
      "isViewed": notification.isViewed,
      "name": notification.name,
      "timeCreated": notification.timeCreated.toIso8601String(),
      "id": notification.id,
      "userId": notification.userId
    };
  }
}
