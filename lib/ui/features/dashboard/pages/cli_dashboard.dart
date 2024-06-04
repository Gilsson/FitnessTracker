import 'dart:io';
import 'dart:math';

import 'package:fitness_sync/application/activity_tracker/activity_tracker_service.dart';
import 'package:fitness_sync/application/meal_planner/meal_schedule_service.dart';
import 'package:fitness_sync/application/meal_planner/user_meals_schedule.dart';
import 'package:fitness_sync/application/notifications/notifications_service.dart';
import 'package:fitness_sync/application/sleep_planner/sleep_planner_service.dart';
import 'package:fitness_sync/application/user/user_statistics_service.dart';
import 'package:fitness_sync/application/workout_tracker/workout_service.dart';
import 'package:fitness_sync/domain/abstractions/unit_of_work.dart';
import 'package:fitness_sync/domain/entities/data/exercise.dart';
import 'package:fitness_sync/domain/entities/data/heart_rate.dart';
import 'package:fitness_sync/domain/entities/data/sleep_data.dart';
import 'package:fitness_sync/domain/entities/data/statistics.dart';
import 'package:fitness_sync/domain/entities/data/step_data.dart';
import 'package:fitness_sync/domain/entities/data/workout.dart';
import 'package:fitness_sync/domain/entities/meals/meals.dart';
import 'package:fitness_sync/domain/entities/user/user_domain.dart';
import 'package:fitness_sync/domain/entities/water/water.dart';

class CliDashboardPage {
  UnitOfWork unitOfWork;
  late UserStatisticsService statService;
  late ActivityTrackerService activityService;
  late SleepPlannerService sleepService;
  late UserMealsScheduleService userMealScheduleService;
  late MealScheduleService mealScheduleService;
  late WorkoutService workoutService;
  late NotificationService notificationService;
  UserDomain user;

  CliDashboardPage(this.unitOfWork, this.user) {
    statService = UserStatisticsService(unitOfWork: unitOfWork);
    activityService = ActivityTrackerService(unitOfWork: unitOfWork);
    sleepService = SleepPlannerService(unitOfWork: unitOfWork);
    userMealScheduleService = UserMealsScheduleService(unitOfWork: unitOfWork);
    workoutService = WorkoutService(unitOfWork: unitOfWork);
    notificationService = NotificationService(unitOfWork: unitOfWork);
    mealScheduleService = MealScheduleService(unitOfWork: unitOfWork);
  }

  Future<void> bodyMassIndexView() async {
    clearConsole();
    stdout.writeln('''
=========================================
          BMI (BODY MASS INDEX)
=========================================''');
    while (true) {
      stdout.writeln('''
1. 📏 Get BMI
2. 📊 Get statistics data
3. ➕ Add statistics
4. 🚪 Exit
''');
      var choose = stdin.readLineSync();
      if (choose != null) {
        switch (choose) {
          case '1':
            var stat = await statService.getBMI(user.id);
            if (stat == null) {
              stdout.writeln("User Body Mass Index not found");
              break;
            }
            stdout.writeln("User Body Mass Index: $stat");
          case '2':
            var stat = await statService.getUserHeight(user.id);
            if (stat == null) {
              stdout.writeln("Statistics not found");
              break;
            }
            var map = stat.toMap();
            stdout.writeln("Statistics: $map");
            stat = await statService.getUserWeight(user.id);
            if (stat == null) {
              stdout.writeln("Statistics not found");
              break;
            }
            map = stat.toMap();
            stdout.writeln("Statistics: $map");
          case '3':
            var stat = await statService.addStatistics(
                user.id,
                Statistics(
                    type: StatisticsType.height,
                    value: Random().nextDouble() * 2.5));
            var map = stat.toMap();
            stdout.writeln("Added statistics: $map");
            stat = await statService.addStatistics(
                user.id,
                Statistics(
                    type: StatisticsType.weight,
                    value: Random().nextDouble() * 100.0));
            map = stat.toMap();
            stdout.writeln("Added statistics: $map");
        }
        if (choose == "4") {
          break;
        }
      }
    }
  }

  void clearConsole() {
    if (Platform.isWindows) {
      stdout.write('\x1B[2J\x1B[0f');
    } else {
      stdout.write('\x1B[2J\x1B[3J\x1B[H');
    }
  }

  Future<void> heartRateData() async {
    clearConsole();
    stdout.writeln('''
=========================================
             HEART RATE MENU
=========================================
''');
    while (true) {
      stdout.writeln('''
1. ❤️ Get heart rate
2. ❤️ Add heart rate
3. 🚪 Exit
''');
      var choose = stdin.readLineSync();
      if (choose != null) {
        switch (choose) {
          case '1':
            var now = DateTime.now();
            var steps = await activityService.getHeartRateByDate(
                user.id, now.subtract(const Duration(seconds: 15)), now);
            if (steps.isEmpty) {
              stdout.writeln("Heart rate not found");
              break;
            }
            var map = steps.map((step) => step.toMap());
            stdout.writeln("Heart rate: $map");
          case '2':
            var rate = await activityService.addHeartRate(
                user.id,
                HeartRateData(
                    rate: Random().nextInt(100),
                    date: DateTime.now(),
                    duration: Duration(seconds: Random().nextInt(30))));
            var map = rate.toMap();
            stdout.writeln("Added heart rate: $map");
            break;
          case '3':
            break;
        }
        if (choose == '3') {
          break;
        }
      }
    }
  }

  Future<void> sleepData() async {
    clearConsole();
    stdout.writeln('''
=========================================
             SLEEP DATA MENU
=========================================
''');
    while (true) {
      stdout.writeln('''
1. 🛌 Add sleep data
2. 🛌 Get sleep data
3. 🌜 Get sleep data by stages
4. ⏰ Schedule sleep
5. 🚪 Exit
''');
      var choose = stdin.readLineSync();
      if (choose != null) {
        switch (choose) {
          case ("1"):
            var sleep = await sleepService.addSleepData(
                user.id,
                SleepData(
                    date: DateTime.now(),
                    duration: Duration(minutes: Random().nextInt(100)),
                    sleepStage:
                        SleepStageExtension.fromValue(Random().nextInt(4))));
            var map = sleep.toMap();
            stdout.writeln("Added sleep: $map");
          case ("2"):
            var sleepData = await sleepService.getSleepContinuity(
                user.id, DateTime.now(), 1);
            stdout.writeln("Sleep continuity: $sleepData");
          case ("3"):
            var sleepStages = await sleepService.getAllSleepContinuityByStage(
                user.id, DateTime.now(), 1);
            stdout.writeln("Sleep stages: $sleepStages");
          case ("4"):
            await sleepService.scheduleSleep(
                user.id,
                DateTime.now().add(const Duration(minutes: 5)),
                const Duration(hours: 8));
            stdout.writeln("Sleep scheduled");
          default:
            break;
        }
        if (choose == "5") {
          break;
        }
      }
    }
  }

  Future<void> stepsData() async {
    clearConsole();
    stdout.writeln('''
=========================================
             STEPS DATA MENU
=========================================
''');
    while (true) {
      stdout.writeln('''
1. 👟 Add steps data
2. 👟 Get steps data
3. 🚶‍ Get velocity
4. 🚪 Exit
''');
      var choose = stdin.readLineSync();
      if (choose != null) {
        switch (choose) {
          case ("1"):
            var steps = await activityService.addSteps(
              user.id,
              StepData(
                  steps: Random().nextInt(100),
                  date: DateTime.now(),
                  duration: Duration(seconds: Random().nextInt(30))),
            );
            var map = steps.toMap();
            stdout.writeln("Added steps: $map");
          case ("2"):
            var now = DateTime.now();
            var steps = await activityService.getStepsByDate(
                user.id, now.subtract(const Duration(seconds: 15)), now);
            if (steps.isEmpty) {
              stdout.writeln("Steps not found");
              break;
            }
            var map = steps.map((step) => step.toMap());
            stdout.writeln("Steps: $map");
          case ("3"):
            var now = DateTime.now();
            var speed = await activityService.getSpeed(
                user.id, now.subtract(const Duration(seconds: 15)), now);
            stdout.writeln("Velocity: $speed");
          default:
            break;
        }
        if (choose == "4") {
          break;
        }
      }
    }
  }

  Future<void> waterIntake() async {
    clearConsole();
    stdout.writeln('''
=========================================
             WATER INTAKE MENU
=========================================
''');
    while (true) {
      stdout.writeln('''
1. 💧 Add water intake
2. 💧 Get water intake
3. 🚪 Exit
''');
      var choose = stdin.readLineSync();
      if (choose != null) {
        switch (choose) {
          case ("1"):
            var water = await activityService.addWaterData(
                user.id,
                Water(
                    amount: Random().nextInt(100), dateTaken: DateTime.now()));
            var map = water.toMap();
            stdout.writeln("Added water data: $map");
          case ("2"):
            var now = DateTime.now();
            var water = await activityService.getWaterByDate(
                user.id, now.subtract(const Duration(seconds: 15)), now);
            if (water.isEmpty) {
              stdout.writeln("Water not found");
              break;
            }
            var map = water.map((item) => item.toMap());
            stdout.writeln("Water: $map");
        }
        if (choose == "3") {
          break;
        }
      }
    }
  }

  void suggestMeals(String timeOfDay) async {
    clearConsole();
    var avocadoToast = Meals.empty();
    avocadoToast.name = "Avocado Toast";
    avocadoToast.nutrients = {
      Nutrients.fats: 10,
      Nutrients.fibre: 5,
      Nutrients.proteins: 3
    };
    avocadoToast.calories = 250;
    avocadoToast.description = "Healthy and delicious breakfast option";
    avocadoToast.ingredients = {"avocado": "1", "bread slices": "2"};
    avocadoToast.cookList = [
      "Toast the bread until golden brown.",
      "Mash the avocado and spread it evenly on the toast.",
      "Sprinkle salt and pepper to taste."
    ];
    avocadoToast.mealType = MealType.breakfast;

    var greekYogurtFruit = Meals.empty();
    greekYogurtFruit.name = "Greek Yogurt with Fruit";
    greekYogurtFruit.nutrients = {
      Nutrients.proteins: 15,
    };
    greekYogurtFruit.calories = 200;
    greekYogurtFruit.description = "Nutritious and refreshing breakfast option";
    greekYogurtFruit.ingredients = {
      "Greek yogurt": "1 cup",
      "Mixed berries": "1/2 cup",
      "Honey": "1 tbsp"
    };
    greekYogurtFruit.cookList = [
      "Spoon Greek yogurt into a bowl.",
      "Top with mixed berries and drizzle with honey.",
      "Stir gently to combine."
    ];
    greekYogurtFruit.mealType = MealType.breakfast;

    // Creating Meal objects for lunch
    var grilledChickenSalad = Meals.empty();
    grilledChickenSalad.name = "Grilled Chicken Salad";
    grilledChickenSalad.nutrients = {
      Nutrients.proteins: 30,
      Nutrients.fibre: 10,
    };
    grilledChickenSalad.calories = 350;
    grilledChickenSalad.description = "Healthy and satisfying lunch option";
    grilledChickenSalad.ingredients = {
      "Chicken breast": "1",
      "Lettuce": "2 cups",
      "Tomatoes": "1",
      "Cucumber": "1"
    };
    grilledChickenSalad.cookList = [
      "Grill the chicken breast until fully cooked.",
      "Chop the lettuce, tomatoes, and cucumber.",
      "Slice the grilled chicken and mix with the vegetables.",
      "Drizzle olive oil and lemon juice as dressing.",
      "Toss everything together and serve as a salad."
    ];
    grilledChickenSalad.mealType = MealType.lunch;

    var quinoaVeggieBowl = Meals.empty();
    quinoaVeggieBowl.name = "Quinoa Veggie Bowl";
    quinoaVeggieBowl.nutrients = {Nutrients.proteins: 15, Nutrients.fibre: 8};
    quinoaVeggieBowl.calories = 300;
    quinoaVeggieBowl.description = "Nutritious and filling vegetarian meal";
    quinoaVeggieBowl.ingredients = {
      "Quinoa": "1 cup",
      "Mixed vegetables (bell peppers, broccoli, carrots)": "1 cup",
      "Avocado": "1",
      "Chickpeas": "1/2 cup",
      "Lemon": "1",
      "Olive oil": "1 tbsp",
      "Salt and pepper": "to taste"
    };
    quinoaVeggieBowl.cookList = [
      "Cook quinoa according to package instructions.",
      "Roast mixed vegetables in the oven until tender.",
      "Drain and rinse chickpeas.",
      "Slice avocado and drizzle with lemon juice to prevent browning.",
      "Assemble the bowl by layering quinoa, mixed vegetables, chickpeas, and avocado.",
      "Drizzle with olive oil and season with salt and pepper."
    ];
    quinoaVeggieBowl.mealType = MealType.lunch;

    // Creating Meal objects for dinner
    var spaghettiBolognese = Meals(
      mealType: MealType.dinner,
      name: "Spaghetti Bolognese",
      calories: 400,
      nutrients: {Nutrients.proteins: 20, Nutrients.fibre: 8},
    );
    spaghettiBolognese.description = "Classic Italian pasta dish";
    spaghettiBolognese.ingredients = {
      "Spaghetti": "200g",
      "Ground beef": "200g",
      "Onion": "1",
      "Garlic": "2 cloves",
      "Tomato sauce": "1 cup",
      "Italian seasoning": "1 tbsp"
    };
    spaghettiBolognese.cookList = [
      "Cook the spaghetti according to package instructions.",
      "Brown the ground beef with chopped onion and garlic.",
      "Add tomato sauce and Italian seasoning to the beef mixture.",
      "Simmer until the sauce thickens.",
      "Serve the spaghetti with the meat sauce on top."
    ];

    var teriyakiSalmonRice = Meals(
      mealType: MealType.dinner,
      name: "Teriyaki Salmon with Rice",
      nutrients: {Nutrients.proteins: 25, Nutrients.fibre: 5},
      calories: 450,
    );
    teriyakiSalmonRice.description = "Flavorful and nutritious seafood dish";
    teriyakiSalmonRice.ingredients = {
      "Salmon fillet": "1",
      "Teriyaki sauce": "2 tbsp",
      "Rice": "1 cup",
      "Broccoli": "1 cup",
      "Soy sauce": "1 tbsp"
    };
    teriyakiSalmonRice.cookList = [
      "Marinate salmon in teriyaki sauce for 30 minutes.",
      "Cook rice according to package instructions.",
      "Grill or bake salmon until cooked through.",
      "Steam broccoli until tender-crisp.",
      "Serve salmon and broccoli over rice, drizzle with soy sauce."
    ];

    // Creating Meal objects for snacks
    var greekYogurtParfait = Meals(
      name: "Greek Yogurt Parfait",
      nutrients: {Nutrients.proteins: 10, Nutrients.fibre: 5},
      calories: 150,
      mealType: MealType.snacks,
    );
    greekYogurtParfait.description = "Refreshing and satisfying snack option";
    greekYogurtParfait.ingredients = {
      "Greek yogurt": "1/2 cup",
      "Granola": "1/4 cup",
      "Mixed berries": "1/4 cup",
      "Honey": "1 tsp"
    };
    greekYogurtParfait.cookList = [
      "Layer Greek yogurt, granola, and mixed berries in a glass.",
      "Drizzle honey on top for sweetness.",
      "Repeat the layers until the glass is full."
    ];
    greekYogurtParfait.mealType = MealType.snacks;

    var hummusVeggieSticks = Meals(
        name: "Hummus with Veggie Sticks",
        mealType: MealType.snacks,
        nutrients: {Nutrients.proteins: 5, Nutrients.fibre: 3},
        calories: 100);
    hummusVeggieSticks.description = "Healthy and satisfying snack option";
    hummusVeggieSticks.ingredients = {
      "Hummus": "1/2 cup",
      "Carrot sticks": "1/2 cup",
      "Cucumber sticks": "1/2 cup",
      "Bell pepper strips": "1/2 cup"
    };
    hummusVeggieSticks.cookList = [
      "Scoop hummus into a bowl.",
      "Arrange carrot, cucumber, and bell pepper around the bowl.",
      "Dip veggies into hummus and enjoy!"
    ];
    hummusVeggieSticks.mealType = MealType.snacks;
    stdout.writeln('Suggested $timeOfDay Meals:');

    switch (timeOfDay.toLowerCase()) {
      case 'breakfast':
        stdout.writeln('1. 🥑 Avocado Toast:');
        stdout.writeln('   📝 Ingredients:');
        stdout.writeln('   - Avocado');
        stdout.writeln('   - Bread');
        stdout.writeln('   - Salt and pepper');
        stdout.writeln('   📖 Step-by-step guide:');
        stdout.writeln('   1. Toast the bread until golden brown.');
        stdout.writeln(
            '   2. Mash the avocado and spread it evenly on the toast.');
        stdout.writeln('   3. Sprinkle salt and pepper to taste.');
        stdout.writeln('   4. Enjoy your avocado toast!');

        stdout.writeln('2. 🍓 Greek Yogurt with Fruit:');
        stdout.writeln('   📝 Ingredients:');
        stdout.writeln('   - Greek yogurt');
        stdout.writeln(
            '   - Mixed berries (strawberries, blueberries, raspberries)');
        stdout.writeln('   - Honey');
        stdout.writeln('   📖 Step-by-step guide:');
        stdout.writeln('   1. Spoon Greek yogurt into a bowl.');
        stdout.writeln('   2. Top with mixed berries and drizzle with honey.');
        stdout.writeln('   3. Stir gently to combine.');
        stdout.writeln('   4. Enjoy your nutritious yogurt and fruit bowl!');
        stdout.write('\n\nChoose an option: ');
        var choose = stdin.readLineSync();
        if (choose != null) {
          switch (choose) {
            case '1':
              await userMealScheduleService.addMealToSchedule(
                  user.id,
                  UserMeals.part(
                      meal: teriyakiSalmonRice,
                      date: DateTime.now(),
                      isScheduled: true,
                      completed: false));
              break;
            case '2':
              await userMealScheduleService.addMealToSchedule(
                  user.id,
                  UserMeals.part(
                      meal: greekYogurtParfait,
                      date: DateTime.now(),
                      isScheduled: true,
                      completed: false));
              break;
            default:
              stdout.writeln(
                  "Invalid choose of dish, choose only between provided!");
          }
        }
        break;
      case 'lunch':
        stdout.writeln('1. 🥗 Grilled Chicken Salad:');
        stdout.writeln('   📝 Ingredients:');
        stdout.writeln('   - Chicken breast');
        stdout.writeln('   - Lettuce');
        stdout.writeln('   - Tomatoes');
        stdout.writeln('   - Cucumber');
        stdout.writeln('   - Olive oil');
        stdout.writeln('   - Lemon juice');
        stdout.writeln('   📖 Step-by-step guide:');
        stdout.writeln('   1. Grill the chicken breast until fully cooked.');
        stdout.writeln('   2. Chop the lettuce, tomatoes, and cucumber.');
        stdout.writeln(
            '   3. Slice the grilled chicken and mix with the vegetables.');
        stdout.writeln('   4. Drizzle olive oil and lemon juice as dressing.');
        stdout.writeln('   5. Toss everything together and serve as a salad.');

        stdout.writeln('2. 🍲 Quinoa Veggie Bowl:');
        stdout.writeln('   📝 Ingredients:');
        stdout.writeln('   - Quinoa');
        stdout
            .writeln('   - Mixed vegetables (bell peppers, carrots, broccoli)');
        stdout.writeln('   - Chickpeas');
        stdout.writeln('   - Olive oil');
        stdout.writeln('   - Lemon juice');
        stdout.writeln('   📖 Step-by-step guide:');
        stdout.writeln('   1. Cook quinoa according to package instructions.');
        stdout.writeln(
            '   2. Roast mixed vegetables and chickpeas with olive oil.');
        stdout.writeln(
            '   3. Combine cooked quinoa, roasted vegetables, and chickpeas.');
        stdout.writeln('   4. Drizzle with lemon juice and season to taste.');
        stdout.writeln('   5. Enjoy your nutritious and filling veggie bowl!');
        stdout.write('\n\nChoose an option: ');
        var choose = stdin.readLineSync();
        if (choose != null) {
          switch (choose) {
            case '1':
              await userMealScheduleService.addMealToSchedule(
                  user.id,
                  UserMeals.part(
                      meal: grilledChickenSalad,
                      date: DateTime.now(),
                      isScheduled: true,
                      completed: false));
              break;
            case '2':
              await userMealScheduleService.addMealToSchedule(
                  user.id,
                  UserMeals.part(
                      meal: quinoaVeggieBowl,
                      date: DateTime.now(),
                      isScheduled: true,
                      completed: false));
              break;
            default:
              stdout.writeln(
                  "Invalid choose of dish, choose only between provided!");
          }
        }
        break;
      case 'dinner':
        stdout.writeln('1. 🍝 Spaghetti Bolognese:');
        stdout.writeln('   📝 Ingredients:');
        stdout.writeln('   - Spaghetti');
        stdout.writeln('   - Ground beef');
        stdout.writeln('   - Onion');
        stdout.writeln('   - Garlic');
        stdout.writeln('   - Tomato sauce');
        stdout.writeln('   - Italian seasoning');
        stdout.writeln('   📖 Step-by-step guide:');
        stdout.writeln(
            '   1. Cook the spaghetti according to package instructions.');
        stdout.writeln(
            '   2. Brown the ground beef with chopped onion and garlic.');
        stdout.writeln(
            '   3. Add tomato sauce and Italian seasoning to the beef mixture.');
        stdout.writeln('   4. Simmer until the sauce thickens.');
        stdout.writeln('   5. Serve the spaghetti with the meat sauce on top.');

        stdout.writeln('2. 🍱 Teriyaki Salmon with Rice:');
        stdout.writeln('   📝 Ingredients:');
        stdout.writeln('   - Salmon fillet');
        stdout.writeln('   - Teriyaki sauce');
        stdout.writeln('   - Rice');
        stdout.writeln('   - Broccoli');
        stdout.writeln('   - Soy sauce');
        stdout.writeln('   📖 Step-by-step guide:');
        stdout
            .writeln('   1. Marinate salmon in teriyaki sauce for 30 minutes.');
        stdout.writeln('   2. Cook rice according to package instructions.');
        stdout.writeln('   3. Grill or bake salmon until cooked through.');
        stdout.writeln('   4. Steam broccoli until tender-crisp.');
        stdout.writeln(
            '   5. Serve salmon and broccoli over rice, drizzle with soy sauce.');
        stdout.write('\n\nChoose an option: ');
        var choose = stdin.readLineSync();
        if (choose != null) {
          switch (choose) {
            case '1':
              await userMealScheduleService.addMealToSchedule(
                  user.id,
                  UserMeals.part(
                      meal: spaghettiBolognese,
                      date: DateTime.now(),
                      isScheduled: true,
                      completed: false));
              break;
            case '2':
              await userMealScheduleService.addMealToSchedule(
                  user.id,
                  UserMeals.part(
                      meal: teriyakiSalmonRice,
                      date: DateTime.now(),
                      isScheduled: true,
                      completed: false));
              break;
            default:
              stdout.writeln(
                  "Invalid choose of dish, choose only between provided!");
          }
        }
        break;
      case 'snacks':
        stdout.writeln('1. 🥣 Greek Yogurt Parfait:');
        stdout.writeln('   📝 Ingredients:');
        stdout.writeln('   - Greek yogurt');
        stdout.writeln('   - Granola');
        stdout.writeln('   - Mixed berries');
        stdout.writeln('   - Honey');
        stdout.writeln('   📖 Step-by-step guide:');
        stdout.writeln(
            '   1. Layer Greek yogurt, granola, and mixed berries in a glass.');
        stdout.writeln('   2. Drizzle honey on top for sweetness.');
        stdout.writeln('   3. Repeat the layers until the glass is full.');
        stdout.writeln('   4. Enjoy your delicious and healthy parfait!');

        stdout.writeln('2. 🥕 Hummus with Veggie Sticks:');
        stdout.writeln('   📝 Ingredients:');
        stdout.writeln('   - Hummus');
        stdout.writeln('   - Carrot sticks');
        stdout.writeln('   - Cucumber sticks');
        stdout.writeln('   - Bell pepper strips');
        stdout.writeln('   📖 Step-by-step guide:');
        stdout.writeln('   1. Scoop hummus into a bowl.');
        stdout.writeln(
            '   2. Arrange carrot, cucumber, and bell pepper around the bowl.');
        stdout.writeln('   3. Dip veggies into hummus and enjoy!');
        stdout.write('\n\nChoose an option: ');
        var choose = stdin.readLineSync();
        if (choose != null) {
          switch (choose) {
            case '1':
              await userMealScheduleService.addMealToSchedule(
                  user.id,
                  UserMeals.part(
                      meal: greekYogurtParfait,
                      date: DateTime.now(),
                      isScheduled: true,
                      completed: false));
              break;
            case '2':
              await userMealScheduleService.addMealToSchedule(
                  user.id,
                  UserMeals.part(
                      meal: hummusVeggieSticks,
                      date: DateTime.now(),
                      isScheduled: true,
                      completed: false));
              break;
            default:
              stdout.writeln(
                  "Invalid choose of dish, choose only between provided!");
          }
        }
        break;
      default:
        stdout.writeln(
            'Invalid time of day. Please choose from: breakfast, lunch, dinner, snacks');
    }
  }

  Future<void> getMealRecomendations() async {
    clearConsole();
    stdout.write('''
=========================================
            MEAL RECOMENDATIONS
=========================================
''');
    stdout.write('''
1. Breakfast
2. Lunch
3. Dinner
4. Snacks
''');
    var choose = stdin.readLineSync();
    if (choose != null) {
      switch (choose) {
        case '1':
          suggestMeals('breakfast');
          break;
        case '2':
          suggestMeals('lunch');
          break;
        case '3':
          suggestMeals('dinner');
          break;
        case '4':
          suggestMeals('snacks');
          break;
        default:
          break;
      }
    }
  }

  Future<void> mealDataView() async {
    clearConsole();
    stdout.writeln('''
=========================================
            CALORIES DATA MENU
=========================================
''');
    while (true) {
      stdout.writeln('''
1. 🍽️ Add meal
2. 📅 Get meal schedule
3. 🍲 Get daily calories
4. 🥐 Get nutrients
5. ❌ Remove meal from schedule
6. 🍽️ Find something to eat
7. 🚪 Exit
''');
      var choose = stdin.readLineSync();
      if (choose != null) {
        switch (choose) {
          case ("1"):
            var m = await mealScheduleService.addMealToSchedule(Meals(
                mealType: MealType.breakfast,
                calories: 100,
                name: "Breads",
                nutrients: {}));
            var meal = await userMealScheduleService.addMealToSchedule(
                user.id,
                UserMeals.part(
                    meal: m,
                    date: DateTime.now(),
                    completed: false,
                    isScheduled: true));
            var map = meal.toMap();
            stdout.writeln("Added meal: ${map['name']} - ${map['mealType']}");
          case ("2"):
            var mealList = await userMealScheduleService.getAll(user.id);
            if (mealList.isEmpty) {
              stdout.writeln("Meals not found at schedule!");
              break;
            }
            for (var meal in mealList) {
              var map = meal.toMap();
              stdout.writeln("Meal: ${map['name']} - ${map['mealType']}");
            }
          case ("3"):
            var dailyCalories = await userMealScheduleService.getCalories(
                user.id, 1, DateTime.now());
            stdout.writeln("Daily calories: $dailyCalories");
          case ("4"):
            var breakfastNutrients = await userMealScheduleService
                .getNutritions(user.id, 1, DateTime.now());
            stdout.writeln("Nutrients: $breakfastNutrients");
          case ("5"):
            var meal = await userMealScheduleService.remove(1);
            if (meal != null) {
              var map = meal.toMap();
              stdout.writeln("Removed meal: $map");
            } else {
              stdout.writeln("Meal not found with id: 1");
            }
          case "6":
            await getMealRecomendations();
          default:
            break;
        }
        if (choose == "7") {
          break;
        }
      }
    }
  }

  Future<void> activityView() async {
    clearConsole();
    stdout.writeln('''
=========================================
             DATA MENU
=========================================''');
    while (true) {
      stdout.writeln('''
1. ❤️ Heart rate data
2. 💤 Sleep data
3. 🏃‍ Steps data
4. 💧 Water intake
5. 🚪 Exit
''');

      var choose = stdin.readLineSync();
      if (choose != null) {
        switch (choose) {
          case '1':
            await heartRateData();
          case '2':
            await sleepData();
          case '3':
            await stepsData();
          case '4':
            await waterIntake();
          case '5':
            break;
        }
      }
      if (choose == '5') {
        break;
      }
    }
  }

  Future<void> workoutProgressView() async {
    clearConsole();
    stdout.writeln('''
=========================================
          WORKOUT PROGRESS
=========================================
''');
    while (true) {
      stdout.writeln('''
1. ➕ Add empty workout
2. ➕ Add exercise to workout
3. 📋 Get all exercises in workout
4. 🏋️‍ Get all equipments in workout
5. 💪 Get workout difficulty
6. 🚪 Exit
''');
      var choose = stdin.readLineSync();
      if (choose != null) {
        switch (choose) {
          case ("1"):
            var workout = await workoutService
                .add(Workout(name: "Workout3000", exercises: []));
            var map = workout.toMap();
            stdout.writeln("Added workout: $map");
          case ("2"):
            var exercise = await workoutService.addToWorkout(
                "1",
                Exercise(
                    name: "PowerLifting",
                    category: ExerciseCategory.strength,
                    equipment: EquipmentType.bodyweight,
                    calories: 100,
                    difficulty:
                        DifficultyTypeExtension.fromValue(Random().nextInt(4)),
                    reps: 15,
                    sets: 5,
                    duration: Duration(seconds: Random().nextInt(30))));
            if (exercise == null) {
              stdout.writeln("Workout not found");
              break;
            }
            var map = exercise.toMap();
            stdout.writeln("Added exercise: $map");
          case ("3"):
            var exercises = await workoutService.getAllExercises("1");
            if (exercises.isEmpty) {
              stdout.writeln("Exercises not found");
              break;
            }
            var map = exercises.map((exercise) => exercise.toMap());
            stdout.writeln("Exercises: $map");
          case ("4"):
            var equipments = await workoutService.getAllUniqueEquipment("1");
            if (equipments.isEmpty) {
              stdout.writeln("Equipments not found");
              break;
            }
            var map = equipments.map((equipment) => equipment.customName);
            stdout.writeln("Equipments: $map");
          case ("5"):
            var difficulty = await workoutService.getOverallDifficulty("1");
            var map = difficulty.customName;
            stdout.writeln("Difficulty: $map");
          default:
            break;
        }
        if (choose == "6") {
          break;
        }
      }
    }
  }

  Future<void> notificationsView() async {
    clearConsole();

    stdout.writeln('''
=========================================
             NOTIFICATIONS
=========================================
''');
    while (true) {
      stdout.writeln('''
1. 📩 See notifications
2. 🚪 Exit
''');
      var choose = stdin.readLineSync();
      if (choose != null) {
        switch (choose) {
          case ("1"):
            var notifications =
                await notificationService.getUnviewedNotifications(user.id);
            if (notifications.isEmpty) {
              stdout.writeln("Notifications not found");
              break;
            }
            var map = notifications.map((e) {
              var notificationMap = e.toMap();
              var name = notificationMap['name'];
              var description = notificationMap['description'];
              return "$name - $description";
            }).join('\n');
            stdout.writeln("Notifications: \n $map");
            await notificationService.setNotificationsAsViewed(notifications);
          default:
            break;
        }
        if (choose == "2") {
          break;
        }
      }
    }
  }

  Future<void> mainView() async {
    while (true) {
      clearConsole();
      var heartRateNotifications =
          await notificationService.getHeartRateNotification(user.id);
      var mealNotifications =
          await notificationService.getMealNotification(user.id);
      var workoutNotifications =
          await notificationService.getWorkoutNotifications(user.id);
      var sleepNotifications =
          await notificationService.getSleepNotifications(user.id);
      var waterNotifications =
          await notificationService.getWaterNotifications(user.id);
      var totalNotifications = heartRateNotifications.length +
          mealNotifications.length +
          workoutNotifications.length +
          sleepNotifications.length +
          waterNotifications.length;
      var activityLength = heartRateNotifications.length +
          sleepNotifications.length +
          waterNotifications.length;
      stdout.writeln('''
=========================================
             DASHBOARD ($totalNotifications)
=========================================
1. 📏 BMI (Body Mass Index)
2. 🎯 All notifications
3. 🏃‍ Activity status ($activityLength)
4. 💪 Workout progress (${workoutNotifications.length})
5. 🍔 Meal planner (${mealNotifications.length})
6.  Achievements
6. Exit
''');
      stdout.write("Your choose: ");
      String? choose = stdin.readLineSync();
      switch (choose) {
        case "1":
          await bodyMassIndexView();
        case "2":
          await notificationsView();
        case "3":
          await activityView();
        case "4":
          await workoutProgressView();
        case "5":
          await mealDataView();
        case "6":
          break;
        default:
          break;
      }
      clearConsole();
      if (choose == "6") {
        break;
      }
    }
  }
}
