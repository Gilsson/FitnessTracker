import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_sync/application/auth/firebase_auth.dart';
import 'package:fitness_sync/application/user/user_service.dart';
import 'package:fitness_sync/common/color_extension.dart';
import 'package:fitness_sync/common_widget/round_button.dart';
import 'package:fitness_sync/common_widget/round_textfield.dart';
import 'package:fitness_sync/domain/entities/user/user_domain.dart';
import 'package:fitness_sync/persistence/repository/firebase_unit_of_work.dart';
import 'package:fitness_sync/ui/features/login/complete_profile_view.dart';
import 'package:fitness_sync/ui/features/login/login_view.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isCheck = false;
  bool _showPassword = false;

  Future<void> _register() async {
    try {
      var unitOfWork = FireBaseUnitOfWork();
      FirebaseAuthentication firebaseAuthentication =
          FirebaseAuthentication(unitOfWork: unitOfWork);
      await firebaseAuthentication.signUp(
          mail: _emailController.text,
          password: _passwordController.text,
          name: _firstNameController.text,
          lastName: _lastNameController.text);

      // You can add additional user data to Firestore or another database here

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CompleteProfileView()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showErrorDialog('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showErrorDialog('The account already exists for that email.');
      }
    } catch (e) {
      _showErrorDialog(e.toString());
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hey there,",
                  style: TextStyle(color: TColor.gray, fontSize: 16),
                ),
                Text(
                  "Create an Account",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                RoundTextField(
                  hitText: "First Name",
                  icon: "assets/img/user_text.png",
                  controller: _firstNameController,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  hitText: "Last Name",
                  icon: "assets/img/user_text.png",
                  controller: _lastNameController,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  hitText: "Email",
                  icon: "assets/img/email.png",
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  hitText: "Password",
                  icon: "assets/img/lock.png",
                  obscureText: !_showPassword,
                  controller: _passwordController,
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
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isCheck = !isCheck;
                        });
                      },
                      icon: Icon(
                        isCheck
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank_outlined,
                        color: TColor.gray,
                        size: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "By continuing you accept our Privacy Policy and\nTerm of Use",
                        style: TextStyle(color: TColor.gray, fontSize: 10),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: media.width * 0.4,
                ),
                RoundButton(
                    title: "Register",
                    onPressed: () {
                      if (_firstNameController.text.isNotEmpty &&
                          _lastNameController.text.isNotEmpty &&
                          _emailController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty &&
                          isCheck) {
                        _register();
                      } else {
                        _showErrorDialog(
                            'Please fill all the fields and accept the terms.');
                      }
                    }),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
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
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                    width: media.width * 0.04,
                    height: 50,
                  ),
                  //     GestureDetector(
                  //       onTap: () {},
                  //       child: Container(
                  //         width: 50,
                  //         height: 50,
                  //         alignment: Alignment.center,
                  //         decoration: BoxDecoration(
                  //           color: TColor.white,
                  //           border: Border.all(
                  //             width: 1,
                  //             color: TColor.gray.withOpacity(0.4),
                  //           ),
                  //           borderRadius: BorderRadius.circular(15),
                  //         ),
                  //         child: Image.asset(
                  //           "assets/img/facebook.png",
                  //           width: 20,
                  //           height: 20,
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                ]),
                SizedBox(
                  height: media.width * 0.04,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Login",
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
