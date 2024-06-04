import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_sync/application/auth/firebase_auth.dart';
import 'package:fitness_sync/application/providers/auth_provider.dart';
import 'package:fitness_sync/application/providers/user_provider.dart';
import 'package:fitness_sync/application/providers/user_stats_provider.dart';
import 'package:fitness_sync/application/user/user_service.dart';
import 'package:fitness_sync/common/color_extension.dart';
import 'package:fitness_sync/common_widget/round_button.dart';
import 'package:fitness_sync/common_widget/round_textfield.dart';
import 'package:fitness_sync/domain/entities/user/user_domain.dart';
import 'package:fitness_sync/persistence/repository/firebase_unit_of_work.dart';
import 'package:fitness_sync/ui/features/home/home_view.dart';
import 'package:fitness_sync/ui/features/login/complete_profile_view.dart';
import 'package:fitness_sync/ui/features/login/splash_screen.dart';
import 'package:fitness_sync/ui/features/main_tab/main_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _showPassword = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var provider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      await provider.signIn(
        _emailController.text,
        _passwordController.text,
      );
      await Provider.of<UserStatisticsProvider>(context, listen: false)
          .fetchBMI(provider.userId!);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else if (e.code == 'user-disabled') {
        errorMessage =
            'User corresponding to the given email has been disabled.';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'There is no user corresponding to the given email.';
      } else if (e.code == 'wrong-password') {
        errorMessage =
            'The password is invalid for the given email, or the account corresponding to the email does not have a password set.';
      } else {
        errorMessage = 'Login failed. Please try again.';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: media.height * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hey there,",
                  style: TextStyle(color: TColor.gray, fontSize: 16),
                ),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  controller: _emailController,
                  hitText: "Email",
                  icon: "assets/img/email.png",
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  controller: _passwordController,
                  hitText: "Password",
                  icon: "assets/img/lock.png",
                  obscureText: !_showPassword,
                  rigtIcon: TextButton(
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: 20,
                          height: 20,
                          child: Image.asset(
                            "assets/img/show_password.png",
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            color: TColor.gray,
                          ))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Forgot your password?",
                      style: TextStyle(
                          color: TColor.gray,
                          fontSize: 14,
                          decoration: TextDecoration.underline),
                    ),
                  ],
                ),
                const Spacer(),
                RoundButton(title: "Login", onPressed: _login),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.,
                  children: [
                    Expanded(
                        child: Container(
                      height: 1,
                      color: TColor.gray.withOpacity(0.5),
                    )),
                    Text(
                      "  Or  ",
                      style: TextStyle(color: TColor.black, fontSize: 12),
                    ),
                    Expanded(
                        child: Container(
                      height: 1,
                      color: TColor.gray.withOpacity(0.5),
                    )),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: Container(
                    //     width: 50,
                    //     height: 50,
                    //     alignment: Alignment.center,
                    //     decoration: BoxDecoration(
                    //       color: TColor.white,
                    //       border: Border.all(
                    //         width: 1,
                    //         color: TColor.gray.withOpacity(0.4),
                    //       ),
                    //       borderRadius: BorderRadius.circular(15),
                    //     ),
                    //     child: Image.asset(
                    //       "assets/img/google.png",
                    //       width: 20,
                    //       height: 20,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      width: media.width * 0.5,
                      height: 50,
                    ),
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: Container(
                    //     width: 50,
                    //     height: 50,
                    //     alignment: Alignment.center,
                    //     decoration: BoxDecoration(
                    //       color: TColor.white,
                    //       border: Border.all(
                    //         width: 1,
                    //         color: TColor.gray.withOpacity(0.4),
                    //       ),
                    //       borderRadius: BorderRadius.circular(15),
                    //     ),
                    //     child: Image.asset(
                    //       "assets/img/facebook.png",
                    //       width: 20,
                    //       height: 20,
                    //     ),
                    //   ),
                    // )
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Don’t have an account yet? ",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Register",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
