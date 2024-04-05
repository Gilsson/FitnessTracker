import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/persistence/repository/mock_repository.dart';

class MockUnitOfWork extends UnitOfWork {
  static MockUnitOfWork? instance;
  MockUnitOfWork() {
    mealRepository = MockRepository();
    sleepRepository = MockRepository();
    statisticsRepository = MockRepository();
    stepDataRepository = MockRepository();
    heartRateRepository = MockRepository();
    waterRepository = MockRepository();
    workoutRepository = MockRepository();
    notificationsRepository = MockRepository();
  }

  static UnitOfWork getInstance() {
    if (instance == null) {
      instance = MockUnitOfWork();
      return instance!;
    }
    return instance!;
  }

  @override
  void saveAllAsync() async {
    // TODO: Implement saveAllAsync
  }

  @override
  void deleteDataBaseAsync() async {
    // TODO: Implement deleteDataBaseAsync
  }

  @override
  void createDataBaseAsync() async {
    // TODO: Implement createDataBaseAsync
  }
}
