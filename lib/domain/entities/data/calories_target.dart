import 'package:fitness_sync/domain/entities/data/data.dart';
import 'package:fitness_sync/domain/entities/entity.dart';

class CaloriesTarget extends Data {
  int calories;
  DateTime date;
  CaloriesTarget.full(
      {required String userId,
      required String id,
      required this.calories,
      required this.date})
      : super.withId(userId: userId, id: id);

  CaloriesTarget.now({required this.calories}) : date = DateTime.now();
}
