import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/data/sleep_data.dart';

class SleepPlannerService {
  late UnitOfWork unitOfWork;

  SleepPlannerService({required this.unitOfWork});

  Future<SleepData> addSleepData(String userId, SleepData sleep) async {
    sleep.userId = userId;
    return unitOfWork.sleepRepository.add(sleep);
  }

  Future<SleepData> updateSleepData(SleepData sleep) {
    return unitOfWork.sleepRepository.update(sleep);
  }

  Future<SleepData?> remove(int id) async {
    var sleepData =
        await unitOfWork.sleepRepository.getFirst([(sleep) => sleep.id == id]);
    if (sleepData != null) {
      unitOfWork.sleepRepository.remove(sleepData);
    }
    return sleepData;
  }

  Future<List<SleepData>> getByStageAndDay(
      String userId, SleepStage stage, DateTime date) async {
    return unitOfWork.sleepRepository.getAllListByParams([
      (stamp) =>
          stamp.sleepStage == stage &&
          stamp.date.day == date.day &&
          stamp.userId == userId
    ]);
  }

  Future<SleepData?> getById(String userId, int id) async {
    return unitOfWork.sleepRepository
        .getFirst([(stamp) => stamp.id == id && stamp.userId == userId]);
  }

  Future<int> getSleepContinuity(String userId, DateTime date, int days) async {
    var allStamps = await unitOfWork.sleepRepository.getAllListByParams([
      (stamp) => stamp.date.day <= date.day,
      (stamp) => stamp.date.day >= date.day - days,
      (stamp) => stamp.userId == userId
    ]);
    int continuity = 0;
    for (var stamp in allStamps) {
      continuity += stamp.duration.inMinutes;
    }
    return continuity;
  }

  Future<int> getSleepContinuityByStage(
      String userId, SleepStage stage, int days, DateTime date) {
    DateTime endDate = date; // Assuming 'date' is the end date
    DateTime startDate = date.subtract(Duration(days: days));
    var allStamps = unitOfWork.sleepRepository.getAllListByParams([
      (stamp) => stamp.sleepStage == stage,
      (stamp) =>
          stamp.date.isBefore(endDate.add(Duration(days: 1))) &&
          stamp.date.isAfter(startDate.subtract(Duration(days: 1))),
      (stamp) => stamp.userId == userId
    ]);
    return allStamps.then((stamps) {
      int continuity = 0;
      for (var stamp in stamps) {
        continuity += stamp.duration.inMinutes;
      }
      return continuity;
    });
  }

  Future<List<int>> getSleepContinuityPerDays(
      String userId, int days, DateTime date) async {
    DateTime endDate = date; // Assuming 'date' is the end date
    DateTime startDate = date.subtract(Duration(days: days));
    var allStamps = await unitOfWork.sleepRepository.getAllListByParams([
      (stamp) =>
          stamp.date.isBefore(endDate.add(Duration(days: 1))) &&
          stamp.date.isAfter(startDate.subtract(Duration(days: 1))),
      (stamp) => stamp.userId == userId,
      (stamp) => stamp.isScheduled == false
    ]);
    int today = date.weekday;
    var dayList = [0, 0, 0, 0, 0, 0, 0];
    for (SleepData stamp in allStamps) {
      int pos = (stamp.date.weekday - today + 6) % 7;
      dayList[pos] += stamp.duration.inHours;
    }
    return dayList;
  }

  Future<List<int>> getScheduledSleepContinuityPerDays(
      String userId, int days, DateTime date) async {
    DateTime endDate = date; // Assuming 'date' is the end date
    DateTime startDate = date.subtract(Duration(days: days));
    var allStamps = await unitOfWork.sleepRepository.getAllListByParams([
      (stamp) =>
          stamp.date.isBefore(endDate.add(Duration(days: 1))) &&
          stamp.date.isAfter(startDate.subtract(Duration(days: 1))),
      (stamp) => stamp.userId == userId,
      (stamp) => stamp.isScheduled == true
    ]);
    int today = date.weekday;
    var dayList = [0, 0, 0, 0, 0, 0, 0];
    List<DateTime> datesList =
        List.generate(7, (_) => DateTime.fromMillisecondsSinceEpoch(0));
    for (SleepData stamp in allStamps) {
      int pos = (stamp.date.weekday - today + 6) % 7;
      if (datesList[pos].isBefore(stamp.date)) {
        datesList[pos] = stamp.date;
        dayList[pos] = stamp.duration.inHours;
      }
    }
    for (int i = 1; i < 7; ++i) {
      if (dayList[i] == 0) {
        dayList[i] = dayList[i - 1];
      }
    }
    return dayList;
  }

  Future<Map<SleepStage, int>> getAllSleepContinuityByStage(
      String userId, DateTime date, int days) {
    DateTime endDate = date; // Assuming 'date' is the end date
    DateTime startDate = date.subtract(Duration(days: days));
    var allStamps = unitOfWork.sleepRepository.getAllListByParams([
      (stamp) =>
          stamp.date.isBefore(endDate.subtract(Duration(days: 1))) &&
          stamp.date.isAfter(startDate.add(Duration(days: 1))),
      (stamp) => stamp.userId == userId,
    ]);
    return allStamps.then((stamps) {
      Map<SleepStage, int> result = {};
      for (var stamp in stamps) {
        if (!result.containsKey(stamp.sleepStage)) {
          result[stamp.sleepStage] = 0;
        }
        result[stamp.sleepStage] =
            result[stamp.sleepStage]! + stamp.duration.inMinutes;
      }
      return result;
    });
  }

  Future<List<SleepData>> getAllSleep() {
    return unitOfWork.sleepRepository.getAllList();
  }

  Future<List<SleepData>> getAllSleepByStage(String userId, SleepStage stage) {
    return unitOfWork.sleepRepository.getAllListByParams([
      (sleep) => sleep.sleepStage == stage,
      (sleep) => sleep.userId == userId
    ]);
  }

  Future<List<SleepData>> getAllSleepByUser(String userId) {
    return unitOfWork.sleepRepository
        .getAllListByParams([(sleep) => sleep.userId == userId]);
  }

  Future<List<SleepData>> getAllSleepByUserDates(
      String userId, DateTime date, int days) {
    DateTime endDate = date; // Assuming 'date' is the end date
    DateTime startDate = date.subtract(Duration(days: days));
    return unitOfWork.sleepRepository.getAllListByParams(
      [
        (sleep) => sleep.userId == userId,
        (stamp) =>
            stamp.date.isBefore(endDate.add(Duration(days: 1))) &&
            stamp.date.isAfter(startDate.subtract(Duration(days: 1))),
      ],
    );
  }

  Future<void> scheduleSleep(
      String userId, DateTime time, Duration duration) async {
    addSleepData(
        userId,
        SleepData(
            date: time, duration: duration, sleepStage: SleepStage.planned));
  }

  Future<List<SleepData>> getScheduledSleep(String userId) {
    return unitOfWork.sleepRepository.getAllListByParams([
      (item) => item.sleepStage == SleepStage.planned,
      (item) => item.userId == userId
    ]);
  }
}
