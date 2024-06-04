import 'package:fitness_sync/application/activity_tracker/activity_tracker_service.dart';
import 'package:fitness_sync/application/meal_planner/meal_schedule_service.dart';
import 'package:fitness_sync/application/meal_planner/user_meals_schedule.dart';
import 'package:fitness_sync/application/sleep_planner/sleep_planner_service.dart';
import 'package:fitness_sync/application/workout_tracker/user_workout_service.dart';
import 'package:fitness_sync/application/workout_tracker/workout_service.dart';
import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/data/notification.dart';
import 'package:fitness_sync/domain/entities/data/reminder.dart';
import 'package:fitness_sync/domain/entities/data/workout.dart';
import 'package:fitness_sync/domain/entities/meals/meals.dart';

class NotificationService {
  late UnitOfWork unitOfWork;
  late UserMealsScheduleService scheduleService;
  late ActivityTrackerService activityService;
  late UserWorkoutService userWorkoutService;
  late WorkoutService workoutService;
  late SleepPlannerService sleepService;
  Duration _timeToFutureWorkout = const Duration(minutes: 15);
  Duration _forgottenWorkoutDuration = const Duration(minutes: 15);
  Duration _duration = const Duration(minutes: 15);
  Duration _timeUntilSleep = const Duration(minutes: 15);
  Duration _timeBetweenNotifications = const Duration(seconds: 10);

  NotificationService({required this.unitOfWork}) {
    scheduleService = UserMealsScheduleService(unitOfWork: unitOfWork);
    activityService = ActivityTrackerService(unitOfWork: unitOfWork);
    userWorkoutService = UserWorkoutService(unitOfWork: unitOfWork);
    sleepService = SleepPlannerService(unitOfWork: unitOfWork);
    workoutService = WorkoutService(unitOfWork: unitOfWork);
  }

  set timeForFutureWorkout(Duration time) {
    if (!time.isNegative) _timeToFutureWorkout = time;
  }

  set forgottenWorkoutDuration(Duration time) {
    if (!time.isNegative) _forgottenWorkoutDuration = time;
  }

  set duration(Duration time) {
    if (!time.isNegative) _duration = time;
  }

  Future<void> setNotificationsAsViewed(List<Notification> items) async {
    for (var item in items) {
      item.isViewed = true;
      await unitOfWork.notificationsRepository.update(item);
    }
  }

  Future<Notification> addNotification(
      String userId, Notification notif) async {
    notif.userId = userId;
    var viewed = await getViewedNotifications(userId);
    for (var item in viewed) {
      if (item.name == notif.name) {
        return item;
      }
    }
    return unitOfWork.notificationsRepository.add(notif);
  }

  Future<List<Notification>> getUnviewedNotifications(String userId) async {
    await unitOfWork.notificationsRepository.getAllList();
    return await unitOfWork.notificationsRepository.getAllListByParams(
        [(item) => item.userId == userId, (item) => !item.isViewed]);
  }

  Future<void> markAllAsViewed(String userId) async {
    List<Notification> notifications = await getUnviewedNotifications(userId);
    for (var item in notifications) {
      item.isViewed = true;
      await unitOfWork.notificationsRepository.update(item);
    }
  }

  Future<List<Notification>> getMealNotification(String userId) async {
    List<UserMeals> scheduledMeals =
        await scheduleService.getScheduledMeals(userId);
    List<UserMeals> futureMeals =
        await scheduleService.getFutureMeals(userId, DateTime.now());
    List<Notification> notifications = [];
    for (var meal in scheduledMeals) {
      var notif =
          Reminder(meal.meal.name, DateTime.now().difference(DateTime.now()));
      notif.description = "Hey, it's time for ${meal.meal.mealType.customName}";
      notif.userId = userId;
      notifications.add(notif);
    }
    if (futureMeals.isEmpty) {
      var notif = Notification("Hey, let's add some meals!");
      notif.description = "No future meal scheduled";
      notif.userId = userId;
      notifications.add(notif);
    }
    for (var item in notifications) {
      addNotification(userId, item);
    }
    return notifications;
  }

  Future<List<Notification>> getViewedNotifications(String userId) {
    return unitOfWork.notificationsRepository.getAllListByParams([
      (item) => item.userId == userId,
      (item) => item.isViewed,
      (item) => item.timeCreated
          .add(_timeBetweenNotifications)
          .isAfter(DateTime.now()),
    ]);
  }

  Future<List<Notification>> getSleepNotifications(String userId) async {
    var list = await sleepService.getScheduledSleep(userId);
    List<Notification> notifications = [];
    if (list.isEmpty) {
      var notif = Notification("Sleep schedule not found");
      notif.description =
          "No planned sleep found! Add something to your sleep schedule.";
      notifications.add(notif);
    }
    for (var item in list) {
      if (item.date.subtract(_timeUntilSleep).isBefore(DateTime.now())) {
        var time = item.date.difference(DateTime.now());
        var notif = Reminder("Sleep schedule found", time);

        notif.description =
            "Don't forget about your sleep, that you schedule. It should start in ${time.inMinutes} minutes and will last for ${item.duration}";
        notifications.add(notif);
      }
    }
    for (var item in notifications) {
      addNotification(userId, item);
    }
    return notifications;
  }

  Future<List<Notification>> getHeartRateNotification(String userId) async {
    var list = await activityService.getHeartRateByDate(
        userId, DateTime.now().subtract(_duration), DateTime.now());
    List<Notification> notifications = [];
    if (list.isEmpty) {
      var notif = Notification("Heart rate");
      notif.description =
          "No heart rate data found for previous ${_duration.inMinutes} minutes!Please, measure your heart rate.";
      notifications.add(notif);
    }
    for (var item in notifications) {
      addNotification(userId, item);
    }
    return notifications;
  }

  Future<List<Notification>> getWorkoutNotifications(String userId) async {
    List<UserWorkout> workouts =
        await userWorkoutService.getUncompletedWorkoutsByDate(userId,
            DateTime.now().subtract(_forgottenWorkoutDuration), DateTime.now());
    List<UserWorkout> futureWorkouts =
        await userWorkoutService.getUncompletedWorkoutsByDate(
            userId, DateTime.now(), DateTime.now().add(_timeToFutureWorkout));
    List<Notification> notifications = [];
    if (futureWorkouts.isEmpty) {
      var notif = Notification("Workout");
      notif.description =
          "No future workout found for previous ${_timeToFutureWorkout.inMinutes} minutes! Maybe it's the time?";
      notifications.add(notif);
    }

    for (var workout in workouts) {
      var work = await workoutService.getById(workout.workoutId);
      if (work != null) {
        var notif = Notification(work.name);
        notif.description = "Ups, you have missed your ${work.name}";
        notifications.add(notif);
      }
    }
    for (var item in notifications) {
      addNotification(userId, item);
    }
    return notifications;
  }

  Future<List<Notification>> getWaterNotifications(String userId) async {
    var list = await activityService.getWaterByDate(
        userId, DateTime.now().subtract(_duration), DateTime.now());
    List<Notification> notifications = [];
    if (list.isEmpty) {
      var notif = Notification("Water");
      notif.description =
          "No water data found for previous ${_duration.inMinutes} minutes! Please, drink some water.";
      notifications.add(notif);
    }
    for (var item in notifications) {
      addNotification(userId, item);
    }
    return notifications;
  }

  Future<List<Notification>> getNotifications(String userId) async {
    var list = await getHeartRateNotification(userId);
    list.addAll(await getWorkoutNotifications(userId));
    list.addAll(await getMealNotification(userId));
    list.addAll(await getSleepNotifications(userId));
    list.addAll(await getWaterNotifications(userId));
    return list;
  }
}
