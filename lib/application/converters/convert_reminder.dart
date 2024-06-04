import 'dart:convert';

import 'package:fitness_sync/application/converters/convert_notification.dart';
import 'package:fitness_sync/application/converters/json_converter.dart';
import 'package:fitness_sync/application/converters/parse_duration.dart';
import 'package:fitness_sync/domain/entities/data/reminder.dart';

class ConvertReminderService implements JsonConverter<Reminder> {
  @override
  Reminder decode(String json) {
    return fromJson(jsonDecode(json));
  }

  @override
  String encode(Reminder object) {
    return jsonEncode(toJson(object));
  }

  Map<String, dynamic> toJson(Reminder reminder) {
    var map = ConvertNotificationService().toJson(reminder);
    map["interval"] = reminder.interval.toString();
    map["nextReminderTime"] = reminder.nextReminderTime.toIso8601String();
    return map;
  }

  Reminder fromJson(Map<String, dynamic> json) {
    return Reminder.full(
      description: json["description"],
      isViewed: json["isViewed"],
      name: json["name"],
      timeCreated: DateTime.parse(json["timeCreated"]),
      id: json["id"],
      userId: json["userId"],
      interval: ParseDuration.parseDuration(json["interval"]),
      nextReminderTime: DateTime.parse(json["nextReminderTime"]),
    );
  }
}
