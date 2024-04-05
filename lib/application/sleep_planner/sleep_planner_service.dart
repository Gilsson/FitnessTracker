import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/data/sleep_data.dart';

class SleepPlannerService {
  late UnitOfWork unitOfWork;

  SleepPlannerService({required this.unitOfWork});

  Future<SleepData> addSleepData(int userId, SleepData sleep) async {
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
      int userId, SleepStage stage, DateTime date) async {
    return unitOfWork.sleepRepository.getAllListByParams([
      (stamp) =>
          stamp.sleepStage == stage &&
          stamp.date.day == date.day &&
          stamp.userId == userId
    ]);
  }

  Future<SleepData?> getById(int userId, int id) async {
    return unitOfWork.sleepRepository
        .getFirst([(stamp) => stamp.id == id && stamp.userId == userId]);
  }

  Future<int> getSleepContinuity(int userId, DateTime date, int days) async {
    var allStamps = await unitOfWork.sleepRepository.getAllListByParams([
      (stamp) => stamp.date.day == date.day,
      (stamp) => stamp.userId == userId
    ]);
    int continuity = 0;
    for (var stamp in allStamps) {
      continuity += stamp.duration.inMinutes;
    }
    return continuity;
  }

  Future<int> getSleepContinuityByStage(
      int userId, SleepStage stage, int days, DateTime date) {
    var allStamps = unitOfWork.sleepRepository.getAllListByParams([
      (stamp) => stamp.sleepStage == stage,
      (stamp) => stamp.date.day <= date.day,
      (stamp) => stamp.date.day >= date.day - days,
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

  Future<Map<SleepStage, int>> getAllSleepContinuityByStage(
      int userId, DateTime date, int days) {
    var allStamps = unitOfWork.sleepRepository.getAllListByParams([
      (stamp) => stamp.date.day >= date.day - days,
      (stamp) => stamp.date.day <= date.day,
      (stamp) => stamp.userId == userId
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

  Future<List<SleepData>> getAllSleepByStage(int userId, SleepStage stage) {
    return unitOfWork.sleepRepository.getAllListByParams([
      (sleep) => sleep.sleepStage == stage,
      (sleep) => sleep.userId == userId
    ]);
  }

  Future<List<SleepData>> getAllSleepByUser(int userId) {
    return unitOfWork.sleepRepository
        .getAllListByParams([(sleep) => sleep.userId == userId]);
  }

  Future<void> scheduleSleep(
      int userId, DateTime time, Duration duration) async {
    addSleepData(
        userId,
        SleepData(
            date: time, duration: duration, sleepStage: SleepStage.planned));
  }

  Future<List<SleepData>> getScheduledSleep(int userId) {
    return unitOfWork.sleepRepository.getAllListByParams([
      (item) => item.sleepStage == SleepStage.planned,
      (item) => item.userId == userId
    ]);
  }
}
