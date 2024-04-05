import 'package:fitness_sync/Domain/Entities/Data/Data.dart';
import 'package:fitness_sync/domain/abstractions/repository.dart';

class DataService<T extends Data> {
  late Repository<T> dataRepository;
  DataService(this.dataRepository);

  List<T> getStats(List<bool Function(T)> params) {
    return [];
  }

  T? getStat(List<bool Function(T)> pararms) {
    return null;
  }
}
