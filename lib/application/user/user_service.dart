import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/user/user_domain.dart';

class UserService {
  final UnitOfWork unitOfWork;

  UserService(this.unitOfWork);

  Future<List<UserDomain>> getAll() async {
    return unitOfWork.userRepository.getAllList();
  }

  Future<List<UserDomain>> getByParam(
      List<bool Function(UserDomain)> params) async {
    return unitOfWork.userRepository.getAllListByParams(params);
  }

  Future<UserDomain?> getById(String id) {
    return unitOfWork.userRepository.getFirst([(user) => user.id == id]);
  }

  Future<List<UserDomain>> getByName(String name) {
    return unitOfWork.userRepository
        .getAllListByParams([(user) => user.name == name]);
  }

  Future<UserDomain> add(UserDomain user) {
    return unitOfWork.userRepository.add(user);
  }

  Future<UserDomain?> remove(int id) async {
    var user =
        await unitOfWork.userRepository.getFirst([(user) => user.id == id]);
    if (user != null) {
      unitOfWork.userRepository.remove(user);
    }
    return user;
  }

  Future<UserDomain> update(UserDomain user) {
    return unitOfWork.userRepository.update(user);
  }
}
