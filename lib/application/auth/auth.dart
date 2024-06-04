import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_sync/domain/entities/user/user_domain.dart';

abstract class Authentication {
  Future<UserDomain> signUp(
      {required String mail,
      required String password,
      required String name,
      required String lastName});
  Future<UserCredential?> signIn(
      {required String mail, required String password});
}
