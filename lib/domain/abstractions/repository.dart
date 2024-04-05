import 'package:fitness_sync/domain/entities/entity.dart';

abstract class Repository<T extends Entity> {
  Future<List<T>> getAllList();
  Future<T> update(T entity);
  Future<void> remove(T entity);
  Future<T> add(T entity);
  Future<T?> getFirst(List<bool Function(T)> params);
  Future<T?> getLast(List<bool Function(T)> params);
  Future<List<T>> getAllListByParams(List<bool Function(T)> params);
}
