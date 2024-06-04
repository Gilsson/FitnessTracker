import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:fitness_sync/application/providers/auth_provider.dart';
import 'package:fitness_sync/application/providers/user_meal_provider.dart';
import 'package:fitness_sync/common/color_extension.dart';
import 'package:fitness_sync/common_widget/meal_food_schedule_row.dart';
import 'package:fitness_sync/common_widget/nutritions_row.dart';
import 'package:fitness_sync/domain/entities/meals/meals.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MealScheduleView extends StatefulWidget {
  const MealScheduleView({super.key});

  @override
  State<MealScheduleView> createState() => _MealScheduleViewState();
}

class _MealScheduleViewState extends State<MealScheduleView> {
  CalendarAgendaController _calendarAgendaControllerAppBar =
      CalendarAgendaController();

  late DateTime _selectedDateAppBBar = DateTime.now();

  List breakfastArr = [
    // {
    //   "name": "Honey Pancake",
    //   "time": "07:00am",
    //   "image": "assets/img/honey_pan.png"
    // },
    // {"name": "Coffee", "time": "07:30am", "image": "assets/img/coffee.png"},
  ];

  List lunchArr = [
    // {
    //   "name": "Chicken Steak",
    //   "time": "01:00pm",
    //   "image": "assets/img/chicken.png"
    // },
    // {
    //   "name": "Milk",
    //   "time": "01:20pm",
    //   "image": "assets/img/glass-of-milk 1.png"
    // },
  ];
  List snacksArr = [
    // {"name": "Orange", "time": "04:30pm", "image": "assets/img/orange.png"},
    // {
    //   "name": "Apple Pie",
    //   "time": "04:40pm",
    //   "image": "assets/img/apple_pie.png"
    // },
  ];
  List dinnerArr = [
    // {"name": "Salad", "time": "07:10pm", "image": "assets/img/salad.png"},
    // {"name": "Oatmeal", "time": "08:10pm", "image": "assets/img/oatmeal.png"},
  ];

  List nutritionArr = [
    // {
    //   "title": "Calories",
    //   "image": "assets/img/burn.png",
    //   "unit_name": "kCal",
    //   "value": "350",
    //   "max_value": "500",
    // },
    // {
    //   "title": "Proteins",
    //   "image": "assets/img/proteins.png",
    //   "unit_name": "g",
    //   "value": "300",
    //   "max_value": "1000",
    // },
    // {
    //   "title": "Fats",
    //   "image": "assets/img/egg.png",
    //   "unit_name": "g",
    //   "value": "140",
    //   "max_value": "1000",
    // },
    // {
    //   "title": "Carbo",
    //   "image": "assets/img/carbo.png",
    //   "unit_name": "g",
    //   "value": "140",
    //   "max_value": "1000",
    // },
  ];

  List<Map<String, dynamic>> convertMealsToMap(
      List<UserMeals> userMeals, MealType type) {
    return userMeals
        .where((userMeal) => userMeal.meal.mealType == type)
        .map((userMeal) {
      return {
        "name": userMeal.meal.name,
        "time": DateFormat('hh:mma').format(userMeal.date).toLowerCase(),
        "image": userMeal.meal.icon,
        "calories": userMeal.meal.calories.toString(),
        "meal": userMeal
      };
    }).toList();
  }

  List<UserMeals> userMeals = [];

  void _changeDate(int days) {
    setState(() {
      _selectedDateAppBBar = _selectedDateAppBBar.add(Duration(days: days));
    });
  }

  void setDayMealList() {
    userMeals =
        Provider.of<UserMealProvider>(context, listen: false).dailyMeals;

    breakfastArr = convertMealsToMap(userMeals, MealType.breakfast);
    lunchArr = convertMealsToMap(userMeals, MealType.lunch);
    snacksArr = convertMealsToMap(userMeals, MealType.snacks);
    dinnerArr = convertMealsToMap(userMeals, MealType.dinner);
    nutritionArr = [];
    Map<Nutrients, int> aggregatedNutrients = {};
    userMeals.forEach((userMeal) {
      userMeal.meal.nutrients.forEach((nutrient, value) {
        if (aggregatedNutrients.containsKey(nutrient)) {
          aggregatedNutrients[nutrient] =
              aggregatedNutrients[nutrient]! + value;
        } else {
          aggregatedNutrients[nutrient] = value;
        }
      });
      nutritionArr = aggregatedNutrients.entries.map((entry) {
        return {
          "title": entry.key.customName,
          "image": "assets/img/${entry.key.customName.toLowerCase()}.png",
          "unit_name": 'g',
          "value": entry.value.toString(),
          "max_value": "1000" // Assuming a max value for simplicity
        };
      }).toList();
    });
    if (userMeals.isNotEmpty) {
      // Add calories separately
      int totalCalories =
          userMeals.fold(0, (sum, userMeal) => sum + userMeal.meal.calories);
      nutritionArr.add({
        "title": "Calories",
        "image": "assets/img/burn.png",
        "unit_name": "kCal",
        "value": totalCalories.toString(),
        "max_value": "2000" // Assuming a max value for calories
      });
    }
  }

  bool _isLoading = true;
  String userId = "";

  @override
  void initState() {
    super.initState();
    _selectedDateAppBBar = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (context.mounted) {
        setState(() => _isLoading = true);
        setState(() => _selectedDateAppBBar = DateTime.now());
        userId =
            await Provider.of<AuthenticationProvider>(context, listen: false)
                .userId!;

        await Provider.of<UserMealProvider>(context, listen: false)
            .fetchUser(userId, _selectedDateAppBBar);
        setDayMealList();
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: TColor.white,
          centerTitle: true,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TColor.lightGray,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                "assets/img/back_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          ),
          title: Text(
            "Meal Schedule",
            style: TextStyle(
                color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          actions: [
            InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.all(8),
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: TColor.lightGray,
                    borderRadius: BorderRadius.circular(10)),
                child: Image.asset(
                  "assets/img/more_btn.png",
                  width: 15,
                  height: 15,
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        ),
        backgroundColor: TColor.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/img/back_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Meal  Schedule",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TColor.lightGray,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                "assets/img/more_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CalendarAgenda(
            controller: _calendarAgendaControllerAppBar,
            appbar: false,
            selectedDayPosition: SelectedDayPosition.center,
            weekDay: WeekDay.short,
            dayNameFontSize: 12,
            dayNumberFontSize: 16,
            dayBGColor: Colors.grey.withOpacity(0.15),
            titleSpaceBetween: 15,
            backgroundColor: Colors.transparent,
            // fullCalendar: false,
            fullCalendarScroll: FullCalendarScroll.horizontal,
            fullCalendarDay: WeekDay.short,
            selectedDateColor: Colors.white,
            dateColor: Colors.black,
            locale: 'en',

            initialDate: _selectedDateAppBBar,
            calendarEventColor: TColor.primaryColor2,
            firstDate: DateTime.now().subtract(const Duration(days: 140)),
            lastDate: DateTime.now().add(const Duration(days: 60)),

            onDateSelected: (date) async {
              setState(() {
                _isLoading = true;
                _selectedDateAppBBar = date;
              });

              await Provider.of<UserMealProvider>(context, listen: false)
                  .fetchUser(userId, _selectedDateAppBBar);
              setDayMealList();
              setState(() => _isLoading = false);
            },
            selectedDayLogo: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: TColor.primaryG,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "BreakFast",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "${breakfastArr.length} Items | ${breakfastArr.fold(0, (a, b) => a + int.parse(b["calories"]))} calories",
                          style: TextStyle(color: TColor.gray, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
                ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: breakfastArr.length,
                    itemBuilder: (context, index) {
                      var mObj = breakfastArr[index] as Map? ?? {};
                      return MealFoodScheduleRow(
                        mObj: mObj,
                        index: index,
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Lunch",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "${lunchArr.length} Items |  ${lunchArr.fold(0, (a, b) => a + int.parse(b["calories"]))} calories",
                          style: TextStyle(color: TColor.gray, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
                ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: lunchArr.length,
                    itemBuilder: (context, index) {
                      var mObj = lunchArr[index] as Map? ?? {};
                      return MealFoodScheduleRow(
                        mObj: mObj,
                        index: index,
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Snacks",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "${snacksArr.length} Items | ${snacksArr.fold(0, (a, b) => a + int.parse(b["calories"]))} calories",
                          style: TextStyle(color: TColor.gray, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
                ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snacksArr.length,
                    itemBuilder: (context, index) {
                      var mObj = snacksArr[index] as Map? ?? {};
                      return MealFoodScheduleRow(
                        mObj: mObj,
                        index: index,
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dinner",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "${dinnerArr.length} Items | ${dinnerArr.fold(0, (a, b) => a + int.parse(b["calories"]))} calories",
                          style: TextStyle(color: TColor.gray, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
                ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: dinnerArr.length,
                    itemBuilder: (context, index) {
                      var mObj = dinnerArr[index] as Map? ?? {};
                      return MealFoodScheduleRow(
                        mObj: mObj,
                        index: index,
                      );
                    }),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today Meal Nutritions",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: nutritionArr.length,
                    itemBuilder: (context, index) {
                      var nObj = nutritionArr[index] as Map? ?? {};

                      return NutritionRow(
                        nObj: nObj,
                      );
                    }),
                SizedBox(
                  height: media.width * 0.05,
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
