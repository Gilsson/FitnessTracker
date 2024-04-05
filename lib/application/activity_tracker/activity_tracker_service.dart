import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/data/heart_rate.dart';
import 'package:fitness_sync/domain/entities/data/step_data.dart';
import 'package:fitness_sync/domain/entities/water/water.dart';

class ActivityTrackerService {
  UnitOfWork unitOfWork;
  ActivityTrackerService({required this.unitOfWork});

  Future<StepData> addSteps(int userId, StepData stepData) {
    stepData.userId = userId;
    return unitOfWork.stepDataRepository.add(stepData);
  }

  Future<double> getSteps(int userId, DateTime date, int days) async {
    var list = await unitOfWork.stepDataRepository.getAllListByParams([
      (data) => data.date.day <= date.day,
      (data) => data.date.day >= date.day - days,
      (data) => data.userId == userId
    ]);

    double result = 0;
    for (var data in list) {
      result += data.steps;
    }
    return result;
  }

  Future<double> getSpeed(int userId, DateTime start, DateTime end) async {
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

  Future<HeartRateData> addHeartRate(int userId, HeartRateData heartRate) {
    heartRate.userId = userId;
    return unitOfWork.heartRateRepository.add(heartRate);
  }

  Future<Water> addWaterData(int userId, Water water) {
    water.userId = userId;
    return unitOfWork.waterRepository.add(water);
  }

  Future<List<HeartRateData>> getHeartRate(
      int userId, DateTime date, int days) {
    return unitOfWork.heartRateRepository.getAllListByParams([
      (data) => data.userId == userId,
      (data) => data.date.day <= date.day,
      (data) => data.date.day >= date.day - days
    ]);
  }

  Future<List<HeartRateData>> getHeartRateByDate(
      int userId, DateTime start, DateTime end) {
    return unitOfWork.heartRateRepository.getAllListByParams([
      (data) => data.date.isAfter(start),
      (data) => data.date.isBefore(end),
      (data) => data.userId == userId
    ]);
  }

  Future<List<StepData>> getStepsByDate(
      int userId, DateTime start, DateTime ends) {
    return unitOfWork.stepDataRepository.getAllListByParams([
      (data) => data.date.isAfter(start),
      (data) => data.date.isBefore(ends),
      (data) => data.userId == userId
    ]);
  }

  Future<List<Water>> getWaterByDate(int userId, DateTime start, DateTime end) {
    return unitOfWork.waterRepository.getAllListByParams([
      (data) => data.dateTaken.isAfter(start),
      (data) => data.dateTaken.isBefore(end),
      (data) => data.userId == userId
    ]);
  }

  Future<List<Water>> getWater(int userId, DateTime date, int days) {
    return unitOfWork.waterRepository.getAllListByParams([
      (data) => data.dateTaken.isBefore(date),
      (data) => data.dateTaken.isAfter(date.subtract(Duration(days: days))),
      (data) => data.userId == userId
    ]);
  }
}
