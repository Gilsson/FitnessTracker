import 'dart:io';

import 'package:fitness_sync/application/auth/mock_auth.dart';
import 'package:fitness_sync/application/user/user_statistics_service.dart';
import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/data/statistics.dart';
import 'package:fitness_sync/domain/entities/user/user_domain.dart';

class CliSignupPage {
  MockAuthentication auth = MockAuthentication.getInstance();
  late UserStatisticsService statService;
  UnitOfWork unitOfWork;
  UserDomain? user;
  CliSignupPage(this.unitOfWork) {
    statService = UserStatisticsService(unitOfWork: unitOfWork);
  }
  void mockSignUp() {
    UserDomain user =
        UserDomain(mail: "mail@mail.com", hashPassword: "password");
    user.name = "name";
    this.user = auth.signUp(user: user);
    String? gender = "Male";
    DateTime date = DateTime(2000);
    double weight = 60;
    double height = 1.8;
    statService.addStatistics(
        this.user!.id, Statistics(type: StatisticsType.height, value: height));
    statService.addStatistics(
        this.user!.id, Statistics(type: StatisticsType.weight, value: weight));
    statService.addStatistics(
        this.user!.id,
        Statistics(
            type: StatisticsType.age,
            value: DateTime.now().year.toDouble() - date.year.toDouble()));
    statService.addStatistics(this.user!.id,
        Statistics(type: StatisticsType.sex, value: gender == "Male" ? 0 : 1));
  }

  void signUp() {
    stdout.writeln('''
=========================================
              SIGN UP
=========================================''');
    stdout.write('Name:');
    String? name = stdin.readLineSync();
    stdout.write('Enter email: ');
    String? mail = stdin.readLineSync();

    stdout.write('Enter password: ');
    String? password = stdin.readLineSync();
    UserDomain user;
    if (password != null && mail != null && name != null) {
      user = UserDomain(mail: mail, hashPassword: password);
      user.name = name;
    } else {
      return;
    }
    var anotherUser = auth.signUp(user: user);
    if (anotherUser != null) {
      stdout.write('''
    User created ${user.name}
    ''');
      this.user = anotherUser;
    } else {
      stdout.write('\nInvalid username or password. Please try again.\n');
      return;
    }
    stdout.write('''
    Let's complete your profile
    It will help us to know more about you!\n''');
    stdout.write('Choose gender: ');
    String? gender = "Male";
    stdout.writeln(gender);
    stdout.write('Enter date of birth: ');
    DateTime date = DateTime(2000);
    stdout.writeln(date);
    stdout.write('Your weight: ');
    double weight = 60;
    stdout.write('Your height: ');
    double height = 1.8;
    stdout.writeln(height);
    statService.addStatistics(
        this.user!.id, Statistics(type: StatisticsType.height, value: height));
    statService.addStatistics(
        this.user!.id, Statistics(type: StatisticsType.weight, value: weight));
    statService.addStatistics(
        this.user!.id,
        Statistics(
            type: StatisticsType.age,
            value: DateTime.now().year.toDouble() - date.year.toDouble()));
    statService.addStatistics(this.user!.id,
        Statistics(type: StatisticsType.sex, value: gender == "Male" ? 0 : 1));
  }

  void logIn() {
    stdout.writeln('''
=========================================
              LOG IN
=========================================
    ''');
    stdout.write('Enter email: ');
    String? mail = stdin.readLineSync();

    stdout.write('Enter password: ');
    String? password = stdin.readLineSync();
    UserDomain? user;

    if (password != null && mail != null) {
      user = UserDomain(mail: mail, hashPassword: password);
    } else {
      return;
    }
    this.user = auth.signIn(user: user);
    if (this.user != null) {
      stdout.write('\nWelcome, ${this.user!.name}! You are now logged in.\n');
    } else {
      stdout.write('\nInvalid username or password. Please try again.\n');
    }
  }

  void mainView() {
    while (true) {
      stdout.writeln('''
    Hey there,
    1)Create an Account
    2)Log In
    3)Continue after authentication
    4)Use mock data
''');
      stdout.write("Your choose: ");
      String? choose = stdin.readLineSync();
      if (choose == "1") {
        signUp();
      } else if (choose == "2") {
        logIn();
      } else if (choose == "4") {
        mockSignUp();
      } else {
        if (user == null) {
          stdout.write('''
    You must be logged in to continue
    ''');
        } else {
          break;
        }
      }
    }
  }
}
