import 'dart:io';
import 'package:fitness_sync/domain/entities/user/user_domain.dart';

class MockAuthentication {
  final List<UserDomain> _users = [];
  static MockAuthentication? instance;
  int counter = 0;
  MockAuthentication();

  static MockAuthentication getInstance() {
    if (instance == null) {
      instance = MockAuthentication();
      return instance!;
    }
    return instance!;
  }

  bool checkMail(String mail) {
    final RegExp regex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return regex.hasMatch(mail);
  }

  UserDomain? signUp({required UserDomain user}) {
    for (var exist in _users) {
      if (exist.mail == user.mail) {
        return user;
      }
    }
    if (checkMail(user.mail)) {
      //   stdout.writeln("Mail accepted");
      _users.add(user);
      user.id = counter;
      counter++;
    } else {
      //stdout.writeln("Mail not accepted");
      return null;
    }
    return user;
  }

  UserDomain? signIn({required UserDomain user}) {
    for (var exist in _users) {
      if (exist.mail == user.mail) {
        if (exist.hashPassword == user.hashPassword) {
          return exist;
        }
        stdout.writeln('Wrong password');
        return null;
      }
    }
    stdout.writeln('Email not exist');
    return null;
  }
}
