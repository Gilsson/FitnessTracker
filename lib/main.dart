import 'package:fitness_sync/domain/entities/user/user_domain.dart';
// import 'package:fitness_sync/domain/entities/water/water.dart';
import 'package:fitness_sync/persistence/repository/mock_unit_of_work.dart';
import 'package:fitness_sync/ui/features/auth/pages/cli_signup_page.dart';
import 'package:fitness_sync/ui/features/dashboard/pages/cli_dashboard.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fitness_sync/application/auth_use_case/auth_use_case.dart';
// import 'package:fitness_sync/core/theme/theme.dart';
// import 'package:fitness_sync/ui/features/auth/pages/signup_page.dart';
// import 'package:fitness_sync/ui/features/on_boarding/widgets/on_boarding_view.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

Future<void> main() async {
//   runApp(const MyApp());
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
  // options: DefaultFirebaseOptions.currentPlatform,
//   );
  var unitOfWork = MockUnitOfWork();
  CliSignupPage cliSignupPage = CliSignupPage(unitOfWork);
  cliSignupPage.mainView();
  UserDomain user = cliSignupPage.user!;
  CliDashboardPage cliDashboardPage = CliDashboardPage(unitOfWork, user);
  await cliDashboardPage.mainView();
  // FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();
  // if (choose != null) {
  //   switch (choose) {
  //     case ("1"):
  //       if (mail != null && password != null) {
  //         firebaseAuthentication.signIn(mail: mail, password: password);
  //       }
  //     case ("2"):
  //       if (mail != null && password != null) {
  //         firebaseAuthentication.signUp(mail: mail, password: password);
  //       }
  //   }
  // }
  //}
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Fitness Tracker',
//         theme: AppTheme.lightThemeMode,
//         home: const OnBoardingView());
//   }
// }
// 