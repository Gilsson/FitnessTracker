import 'package:fitness_sync/domain/abstractions/repository.dart';
import 'package:fitness_sync/domain/entities/user/user_domain.dart';

abstract class UserRepository extends Repository<UserDomain> {
  Future<UserDomain?> getByEmail(String email);
}
