import 'package:fitness_sync/application/user/user_service.dart';
import 'package:fitness_sync/domain/entities/user/user_domain.dart';
import 'package:flutter/material.dart';
import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService;

  UserProvider(UnitOfWork unitOfWork) : _userService = UserService(unitOfWork);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserDomain? _user;
  UserDomain? get user => _user;
  Future<void> fetchUser(String userId) async {
    _isLoading = true;
    notifyListeners();
    _user = await _userService.getById(userId);
    _isLoading = false;
    notifyListeners();
  }
}
