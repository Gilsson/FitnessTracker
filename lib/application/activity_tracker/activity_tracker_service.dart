import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/data/heart_rate.dart';
import 'package:fitness_sync/domain/entities/data/step_data.dart';
import 'package:fitness_sync/domain/entities/water/water.dart';

class ActivityTrackerService {
  UnitOfWork unitOfWork;
  ActivityTrackerService({required this.unitOfWork});

  Future<StepData> addSteps(String userId, StepData stepData) {
    stepData.userId = userId;
    return unitOfWork.stepDataRepository.add(stepData);
  }

  Future<List<StepData>> getScheduledSteps(String userId) async {
    var list = await unitOfWork.stepDataRepository.getAllList();
    return await unitOfWork.stepDataRepository.getAllListByParams(
        [(data) => data.isScheduled == true && data.userId == userId]);
  }

  Future<List<Water>> getScheduledWater(String userId) {
    return unitOfWork.waterRepository.getAllListByParams(
        [(data) => data.isScheduled == true, (data) => data.userId == userId]);
  }

  Future<List<int>> getStepsPerDays(
      String userId, int days, DateTime date) async {
    DateTime endDate = date; // Assuming 'date' is the end date
    DateTime startDate = date.subtract(Duration(days: days));
    var allStamps = await unitOfWork.stepDataRepository.getAllListByParams([
      (stamp) => stamp.date.isBefore(endDate) && stamp.date.isAfter(startDate),
      (stamp) => stamp.userId == userId,
      (stamp) => stamp.isScheduled == false
    ]);
    int today = date.weekday;
    var dayList = [0, 0, 0, 0, 0, 0, 0];
    for (StepData stamp in allStamps) {
      int pos = (stamp.date.weekday - today + 6) % 7;
      dayList[pos] += stamp.steps + 1;
    }
    return dayList;
  }

  Future<List<int>> getScheduledStepsPerDays(
      String userId, int days, DateTime date) async {
    DateTime endDate = date; // Assuming 'date' is the end date
    DateTime startDate = date.subtract(Duration(days: days));
    var allStamps = await unitOfWork.stepDataRepository.getAllListByParams([
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
    for (StepData stamp in allStamps) {
      int pos = (stamp.date.weekday - today + 6) % 7;
      if (datesList[pos].isBefore(stamp.date)) {
        datesList[pos] = stamp.date;
        dayList[pos] = stamp.steps;
      }
    }
    for (int i = 1; i < 7; ++i) {
      if (dayList[i] == 0) {
        dayList[i] = dayList[i - 1];
      }
    }
    return dayList;
  }

  Future<List<int>> getWaterPerDays(
      String userId, int days, DateTime date) async {
    DateTime endDate = date; // Assuming 'date' is the end date
    DateTime startDate = date.subtract(Duration(days: days));
    var allStamps = await unitOfWork.waterRepository.getAllListByParams([
      (stamp) =>
          stamp.dateTaken.isBefore(endDate.add(Duration(days: 1))) &&
          stamp.dateTaken.isAfter(startDate.subtract(Duration(days: 1))),
      (stamp) => stamp.userId == userId,
      (stamp) => stamp.isScheduled == false
    ]);
    int today = date.weekday;
    var dayList = [0, 0, 0, 0, 0, 0, 0];
    for (Water stamp in allStamps) {
      int pos = (stamp.dateTaken.weekday - today + 6) % 7;
      dayList[pos] += stamp.amount;
    }
    return dayList;
  }

  Future<List<int>> getScheduledWaterPerDays(
      String userId, int days, DateTime date) async {
    DateTime endDate = date; // Assuming 'date' is the end date
    DateTime startDate = date.subtract(Duration(days: days));
    var allStamps = await unitOfWork.waterRepository.getAllListByParams([
      (stamp) =>
          stamp.dateTaken.isBefore(endDate.add(Duration(days: 1))) &&
          stamp.dateTaken.isAfter(startDate.subtract(Duration(days: 1))),
      (stamp) => stamp.userId == userId,
      (stamp) => stamp.isScheduled == true
    ]);
    int today = date.weekday;
    var dayList = [0, 0, 0, 0, 0, 0, 0];
    List<DateTime> datesList =
        List.generate(7, (_) => DateTime.fromMillisecondsSinceEpoch(0));
    for (Water stamp in allStamps) {
      int pos = (stamp.dateTaken.weekday - today + 6) % 7;
      if (datesList[pos].isBefore(stamp.dateTaken)) {
        datesList[pos] = stamp.dateTaken;
        dayList[pos] = stamp.amount;
      }
    }
    for (int i = 1; i < 7; ++i) {
      if (dayList[i] == 0) {
        dayList[i] = dayList[i - 1];
      }
    }
    return dayList;
  }

  Future<double> getSteps(String userId, DateTime date, int days) async {
    DateTime endDate = date; // Assuming 'date' is the end date
    DateTime startDate = date.subtract(Duration(days: days));
    var list = await unitOfWork.stepDataRepository.getAllListByParams([
      (data) =>
          data.date.isBefore(endDate.add(Duration(days: 1))) &&
          data.date.isAfter(startDate.subtract(Duration(days: 1))),
      (data) => data.userId == userId
    ]);

    double result = 0;
    for (var data in list) {
      result += data.steps;
    }
    return result;
  }

  Future<double> getSpeed(String userId, DateTime start, DateTime end) async {
    var list = await unitOfWork.stepDataRepository.getAllListByParams([
      (data) => data.date.isAfter(start),
      (data) => data.date.isBefore(end),
      (data) => data.userId == userId
    ]);

    double totalSteps = 0;
    for (var data in list) {
      totalSteps += data.steps;
    }
    double strideLength = 0.7;
    double totalDistance = totalSteps * strideLength;
    double totalTimeInSeconds = (end.difference(start)).inSeconds.toDouble();
    double speed = totalDistance / totalTimeInSeconds;

    return speed;
  }

  Future<HeartRateData> addHeartRate(String userId, HeartRateData heartRate) {
    heartRate.userId = userId;
    return unitOfWork.heartRateRepository.add(heartRate);
  }

  Future<Water> addWaterData(String userId, Water water) {
    water.userId = userId;
    return unitOfWork.waterRepository.add(water);
  }

  Future<List<HeartRateData>> getHeartRate(
      String userId, DateTime date, int days) {
    DateTime endDate = date; // Assuming 'date' is the end date
    DateTime startDate = date.subtract(Duration(days: days));

    return unitOfWork.heartRateRepository.getAllListByParams([
      (data) => data.userId == userId,
      (data) =>
          data.date.isBefore(endDate.add(Duration(days: 1))) &&
          data.date.isAfter(startDate.subtract(Duration(days: 1))),
    ]);
  }

  Future<List<HeartRateData>> getHeartRateByDate(
      String userId, DateTime start, DateTime end) {
    return unitOfWork.heartRateRepository.getAllListByParams([
      (data) => data.date.isAfter(start),
      (data) => data.date.isBefore(end),
      (data) => data.userId == userId
    ]);
  }

  Future<List<StepData>> getStepsByDate(
      String userId, DateTime start, DateTime ends) {
    return unitOfWork.stepDataRepository.getAllListByParams([
      (data) => data.date.isAfter(start),
      (data) => data.date.isBefore(ends),
      (data) => data.userId == userId
    ]);
  }

  Future<List<Water>> getWaterByDate(
      String userId, DateTime start, DateTime end) {
    return unitOfWork.waterRepository.getAllListByParams([
      (data) => data.dateTaken.isAfter(start),
      (data) => data.dateTaken.isBefore(end),
      (data) => data.userId == userId,
      (data) => data.isScheduled == false
    ]);
  }

  Future<List<Water>> getWater(String userId, DateTime date, int days) {
    return unitOfWork.waterRepository.getAllListByParams([
      (data) => data.dateTaken.isBefore(date),
      (data) => data.dateTaken.isAfter(date.subtract(Duration(days: days))),
      (data) => data.userId == userId
    ]);
  }
}
