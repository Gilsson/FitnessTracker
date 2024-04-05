import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/user/user_domain.dart';

class ProfileService {
  late UnitOfWork unitOfWork;

  ProfileService({required this.unitOfWork});

  Future<UserDomain?> getProfile(int userId) async {
    var user =
        await unitOfWork.userRepository.getFirst([(user) => user.id == userId]);
    if (user != null) {
      return user;
    }
    return null;
  }
}
