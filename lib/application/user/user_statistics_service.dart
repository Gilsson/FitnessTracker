import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/data/statistics.dart';

class UserStatisticsService {
  final UnitOfWork unitOfWork;

  UserStatisticsService({required this.unitOfWork});

  Future<Statistics?> getUserWeight(String userId) {
    return unitOfWork.statisticsRepository.getLast([
      (stat) => stat.type == StatisticsType.weight,
      (stat) => stat.userId == userId
    ]);
  }

  Future<Statistics?> getUserHeight(String userId) {
    return unitOfWork.statisticsRepository.getLast([
      (stat) => stat.type == StatisticsType.height,
      (stat) => stat.userId == userId
    ]);
  }

  Future<double?> getBMI(String userId) async {
    var weight = await getUserWeight(userId);
    var height = await getUserHeight(userId);
    if (height != null && weight != null) {
      if (height.value == 0 || weight.value == 0) {
        return 0;
      }
      return weight.value / (height.value * height.value);
    }
    return null;
  }

  Future<Statistics> addStatistics(String userId, Statistics statistics) {
    statistics.userId = userId;
    return unitOfWork.statisticsRepository.add(statistics);
  }

  Future<Statistics> update(Statistics statistics) {
    return unitOfWork.statisticsRepository.update(statistics);
  }

  Future<Statistics?> remove(int id) async {
    var stat = await unitOfWork.statisticsRepository
        .getFirst([(stat) => stat.id == id]);
    if (stat != null) {
      unitOfWork.statisticsRepository.remove(stat);
    }
    return stat;
  }

  Future<List<Statistics>> getAllList(String userId) {
    return unitOfWork.statisticsRepository
        .getAllListByParams([(stat) => stat.userId == userId]);
  }
}
