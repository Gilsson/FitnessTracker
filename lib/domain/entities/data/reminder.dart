import 'package:fitness_sync/domain/entities/data/notification.dart';

class Reminder extends Notification {
  Duration interval;
  late DateTime nextReminderTime;
  Reminder.full(
      {required this.interval,
      required this.nextReminderTime,
      required String description,
      required bool isViewed,
      required String name,
      required DateTime timeCreated,
      required int id,
      required int userId})
      : super.withId(
            description: description,
            isViewed: isViewed,
            name: name,
            timeCreated: timeCreated,
            id: id,
            userId: userId);
  Reminder(String name, this.interval) : super(name) {
    calculateNextReminderTime();
  }

  void calculateNextReminderTime() {
    nextReminderTime = DateTime.now().add(interval);
  }
}
