import 'package:fitness_sync/domain/abstractions/repository.dart';
import 'package:fitness_sync/domain/entities/entity.dart';

class MockRepository<T extends Entity> extends Repository<T> {
  List<T> list = [];
  int counter = 1;

  @override
  Future<List<T>> getAllList() async {
    return await Future(() => list);
  }

  @override
  Future<T> update(T entity) async {
    for (var a in list) {
      if (a.id == entity.id) {
        a = entity;
        break;
      }
    }
    return entity;
  }

  @override
  Future<void> remove(T entity) {
    for (var a in list) {
      if (a.id == entity.id) {
        list.remove(a);
        break;
      }
    }
    return Future(() => null);
  }

  @override
  Future<T> add(T entity) async {
    list.add(entity);
    entity.id = counter.toString();
    counter++;
    return entity;
  }

  @override
  Future<T?> getFirst(List<bool Function(T)> params) async {
    for (var meal in list) {
      if (params.every((param) => param(meal))) {
        return Future(() => meal);
      }
    }
    return Future(() => null);
  }

  @override
  Future<T?> getLast(List<bool Function(T)> params) async {
    for (var meal in list.reversed) {
      if (params.every((param) => param(meal))) {
        return Future(() => meal);
      }
    }
    return Future(() => null);
  }

  @override
  Future<List<T>> getAllListByParams(List<bool Function(T)> params) async {
    List<T> paramsList = [];
    for (var user in list) {
      if (params.every((param) => param(user))) {
        paramsList.add(user);
      }
    }
    return paramsList;
  }
}
