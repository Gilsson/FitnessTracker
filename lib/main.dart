import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_sync/application/providers/auth_provider.dart';
import 'package:fitness_sync/application/providers/meal_provider.dart';
import 'package:fitness_sync/application/providers/today_target_provider.dart';
import 'package:fitness_sync/application/providers/user_health_provider.dart';
import 'package:fitness_sync/application/providers/user_meal_provider.dart';
import 'package:fitness_sync/application/providers/user_provider.dart';
import 'package:fitness_sync/application/providers/user_stats_provider.dart';
import 'package:fitness_sync/application/providers/user_workout_provider.dart';
import 'package:fitness_sync/application/providers/workout_provider.dart';
import 'package:fitness_sync/common/color_extension.dart';
import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/firebase_options.dart';
import 'package:fitness_sync/persistence/repository/firebase_unit_of_work.dart';
import 'package:fitness_sync/ui/features/login/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  UnitOfWork uow = FireBaseUnitOfWork.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider(uow)),
        ChangeNotifierProvider(
            create: (context) => UserStatisticsProvider(uow)),
        ChangeNotifierProvider(
            create: (context) => AuthenticationProvider(uow)),
        ChangeNotifierProvider(create: (context) => TodayTargetProvider(uow)),
        ChangeNotifierProvider(create: (context) => UserHealthProvider(uow)),
        ChangeNotifierProvider(create: (context) => WorkoutProvider(uow)),
        ChangeNotifierProvider(create: (context) => UserWorkoutProvider(uow)),
        ChangeNotifierProvider(create: (context) => MealProvider(uow)),
        ChangeNotifierProvider(create: (context) => UserMealProvider(uow)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness 3 in 1',
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primaryColor: TColor.primaryColor1, fontFamily: "Poppins"),
      home: SplashScreen(),
    );
  }
}

// Future<void> main() async {
//   UnitOfWork unitOfWork = MockUnitOfWork();
//   UserDomain user = UserDomain.full(
//       name: "Test",
//       mail: "Test",
//       hashPassword: "Test",
//       achievements: [
//         Achievement.full(
//             name: "Test",
//             tasksToAchieve: [
//               Task.full(
//                   currentProgress: "100",
//                   name: "Test",
//                   timeCompleted: DateTime.now(),
//                   dateTaken: DateTime.now(),
//                   id: 1,
//                   value: "f")
//             ],
//             description: "description",
//             achievementType: AchievementType.running,
//             timeTaken: DateTime.now())
//       ],
//       stepData: [
//         StepData(steps: 100, date: DateTime.now(), duration: Duration(days: 2))
//       ],
//       sleepData: [
//         SleepData(
//             date: DateTime.now(),
//             duration: Duration(hours: 2),
//             sleepStage: SleepStage.deep)
//       ],
//       heartRateData: [
//         HeartRateData(
//             date: DateTime.now(), rate: 100, duration: Duration(minutes: 1))
//       ],
//       userData: [
//         HeartRateData(
//             date: DateTime.now(), rate: 100, duration: Duration(minutes: 1))
//       ]);
//   var convertUserService = ConvertUserService(
//       achievementsService: ConvertAchievementsService(
//           taskService: ConvertTaskService(unitOfWork: unitOfWork),
//           unitOfWork: unitOfWork),
//       unitOfWork: unitOfWork,
//       heartRateService: HeartConvertService(),
//       sleepService: SleepConvertService(),
//       stepService: StepConverterService(),
//       userDataService: UserDataConverterService());
// //   stdout.writeln(convertUserService.decode(convertUserService.encode(user)));
//   MealConverter mealConverter = MealConverter();
//   Meals meal = Meals.full(
//       name: "Test",
//       mealType: MealType.breakfast,
//       timeTaken: DateTime.now(),
//       nutrients: {"test": 1},
//       calories: 100,
//       description: "Test",
//       ingredients: {"test": "test"},
//       cookList: ["test"],
//       isCompleted: true,
//       id: 1,
//       userId: 1);
//   print(mealConverter.encode(mealConverter.decode(mealConverter.encode(meal))));
//   ExerciseConverter exerciseConverter = ExerciseConverter();
//   Exercise exercise = Exercise.full(
//       date: DateTime.now(),
//       duration: Duration(minutes: 1),
//       name: "Test",
//       description: "Test",
//       timeCompleted: DateTime.now(),
//       id: 1,
//       userId: 1,
//       category: ExerciseCategory.cardivascular,
//       difficulty: DifficultyType.easy,
//       equipment: EquipmentType.dumbbell,
//       guide: ["Test"],
//       sets: 1,
//       reps: 1,
//       calories: 100,
//       completed: true);
//   print(ToNotificationConverterService().toNotification(exercise.toMap()));
//   print(exerciseConverter
//       .encode(exerciseConverter.decode(exerciseConverter.encode(exercise))));
//   Workout workout = Workout.full(
//       name: "Test",
//       description: "Test",
//       difficulty: DifficultyType.easy,
//       completed: true,
//       date: DateTime.now(),
//       duration: Duration(minutes: 1),
//       exercises: [exercise],
//       id: 1,
//       userId: 1);
//   WorkoutConverter workoutConverter = WorkoutConverter();
//   print(workoutConverter
//       .encode(workoutConverter.decode(workoutConverter.encode(workout))));
//   ConvertNotification convertNotification = ConvertNotification();
//   Notification notification = Notification.withId(
//       id: 1,
//       description: "Test",
//       name: "Test",
//       timeCreated: DateTime.now(),
//       isViewed: true,
//       userId: 1);
//   print(convertNotification.decode(convertNotification.encode(notification)));

//   Reminder reminder = Reminder.full(
//       description: "Test",
//       isViewed: true,
//       name: "Test",
//       timeCreated: DateTime.now(),
//       id: 1,
//       userId: 1,
//       interval: Duration(minutes: 1),
//       nextReminderTime: DateTime.now());
//   ConvertReminder convertReminder = ConvertReminder();
//   print(convertReminder.decode(convertReminder.encode(reminder)));

// //   runApp(const MyApp());
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp(
//   // options: DefaultFirebaseOptions.currentPlatform,
// //   );

// //   Achievement achievement = Achievement();
// //   achievement.name = "Test";
// //   achievement.description = "Test";
// //   achievement.achievementType = AchievementType.basic;
// //   achievement.timeTaken = DateTime.now();
// //   var task = Task();
// //   task.name = "Test";
// //   task.dateTaken = DateTime.now();
// //   achievement.tasksToAchieve = [task];
// //   var unitOfWork = MockUnitOfWork();
// //   var taskService = ConvertTaskService(unitOfWork: unitOfWork);
// //   ConvertAchievementsService convertAchievementsService =
// //       ConvertAchievementsService(
// //           unitOfWork: unitOfWork, taskService: taskService);
// //   stdout.writeln(convertAchievementsService
// //       .fromJson(convertAchievementsService.toJson(achievement)));
// //   var str = JsonConverter.encode(achievement);
// //   stdout.write(JsonConverter.decode(str));
// //   var unitOfWork = MockUnitOfWork();
// //   CliSignupPage cliSignupPage = CliSignupPage(unitOfWork);
// //   cliSignupPage.mainView();
// //   UserDomain user = cliSignupPage.user!;
// //   CliDashboardPage cliDashboardPage = CliDashboardPage(unitOfWork, user);
// //   await cliDashboardPage.mainView();
//   // FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();
//   // if (choose != null) {
//   //   switch (choose) {
//   //     case ("1"):
//   //       if (mail != null && password != null) {
//   //         firebaseAuthentication.signIn(mail: mail, password: password);
//   //       }
//   //     case ("2"):
//   //       if (mail != null && password != null) {
//   //         firebaseAuthentication.signUp(mail: mail, password: password);
//   //       }
//   //   }
//   // }
//   //}
// }

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
