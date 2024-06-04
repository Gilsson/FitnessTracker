import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/meals/meals.dart';

class MealScheduleService {
  late UnitOfWork unitOfWork;

  MealScheduleService({required this.unitOfWork});
  Future<Meals> addMealToSchedule(Meals meals) async {
    return unitOfWork.mealRepository.add(meals);
  }

  Future<Meals> updateMealSchedule(Meals meal) {
    return unitOfWork.mealRepository.update(meal);
  }

  Future<Meals?> remove(int id) async {
    var meal =
        await unitOfWork.mealRepository.getFirst([(meal) => meal.id == id]);
    if (meal != null) {
      unitOfWork.mealRepository.remove(meal);
    }
    return meal;
  }

  Future<Meals?> getById(String id) async {
    return unitOfWork.mealRepository.getFirst([(meal) => meal.id == id]);
  }

  Future<List<Meals>> getAll() {
    return unitOfWork.mealRepository.getAllList();
  }
}
