import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_sync/application/converters/convert_achievement.dart';
import 'package:fitness_sync/application/converters/convert_user.dart';
import 'package:fitness_sync/application/providers/auth_provider.dart';
import 'package:fitness_sync/application/providers/user_provider.dart';
import 'package:fitness_sync/application/providers/user_stats_provider.dart';
import 'package:fitness_sync/application/user/user_service.dart';
import 'package:fitness_sync/application/user/user_statistics_service.dart';
import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/persistence/repository/firebase_unit_of_work.dart';
import 'package:fitness_sync/ui/features/login/complete_profile_view.dart';
import 'package:fitness_sync/ui/features/login/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:fitness_sync/ui/features/login/login_view.dart';
import 'package:fitness_sync/ui/features/main_tab/main_tab_view.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserStatus();
    });
  }

  Future<void> _checkUserStatus() async {
    var user =
        await Provider.of<AuthenticationProvider>(context, listen: false).user;
    if (user != null) {
      var stats =
          await Provider.of<UserStatisticsProvider>(context, listen: false).bmi;
      if (stats != null) {
        _navigateToMainTabView();
      } else {
        _navigateToCompleteProfileView();
      }
    } else {
      _navigateToRegisterView();
    }
  }

  void _navigateToMainTabView() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainTabView()),
    );
  }

  void _navigateToCompleteProfileView() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CompleteProfileView()),
    );
  }

  void _navigateToRegisterView() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignUpView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
