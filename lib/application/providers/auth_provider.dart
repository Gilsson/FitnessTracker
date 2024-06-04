import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_sync/application/user/user_service.dart';
import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/user/user_domain.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserService _userService;
  UserDomain? _user;
  String? _userId;

  UserDomain? get user => _user;
  String? get userId => _userId;

  AuthenticationProvider(UnitOfWork unitOfWork)
      : _userService = UserService(unitOfWork) {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    var user = _firebaseAuth.currentUser;
    if (user != null) {
      var users = await _userService.getByParam([(u) => u.mail == user.email]);
      if (users.isNotEmpty) {
        _user = users.first;
        _userId = _user?.id;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', _userId!);
      }
    }
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      var users = await _userService
          .getByParam([(u) => u.mail == userCredential.user?.email!]);
      _user = users.first;
      _userId = _user?.id;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _userId!);
      notifyListeners();
    } catch (e) {
      throw Exception('Login failed: No such user exists');
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      var users = await _userService
          .getByParam([(u) => u.mail == userCredential.user?.email!]);
      _user = users.first;
      _userId = _user?.id;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _userId!);
      notifyListeners();
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    _user = null;
    _userId = null;
    notifyListeners();
  }
}
