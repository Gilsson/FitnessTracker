import 'package:fitness_sync/application/providers/meal_provider.dart';
import 'package:fitness_sync/common/color_extension.dart';
import 'package:fitness_sync/common_widget/meal_category_cell.dart';
import 'package:fitness_sync/common_widget/meal_recommed_cell.dart';
import 'package:fitness_sync/common_widget/popular_meal_row.dart';
import 'package:fitness_sync/domain/entities/meals/meals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'food_info_details_view.dart';

class MealFoodDetailsView extends StatefulWidget {
  final Map eObj;
  const MealFoodDetailsView({super.key, required this.eObj});

  @override
  State<MealFoodDetailsView> createState() => _MealFoodDetailsViewState();
}

class _MealFoodDetailsViewState extends State<MealFoodDetailsView> {
  TextEditingController txtSearch = TextEditingController();

  List categoryArr = [
    {
      "name": "Breakfast",
      "image": "assets/img/c_1.png",
    },
    {
      "name": "Lunch",
      "image": "assets/img/c_2.png",
    },
    {
      "name": "Dinner",
      "image": "assets/img/c_3.png",
    },
    {
      "name": "Snacks",
      "image": "assets/img/c_4.png",
    }
  ];

  List popularArr = [
    // {
    //   "name": "Blueberry Pancake",
    //   "image": "assets/img/f_1.png",
    //   "b_image": "assets/img/pancake_1.png",
    //   "size": "Medium",
    //   "time": "30mins",
    //   "kcal": "230kCal"
    // },
    // {
    //   "name": "Salmon Nigiri",
    //   "image": "assets/img/f_2.png",
    //   "b_image": "assets/img/nigiri.png",
    //   "size": "Medium",
    //   "time": "20mins",
    //   "kcal": "120kCal"
    // },
  ];

  List recommendArr = [
    {
      "name": "Honey Pancake",
      "image": "assets/img/rd_1.png",
      "kcal": "180kCal"
    },
    {"name": "Canai Bread", "image": "assets/img/m_4.png", "kcal": "230kCal"},
  ];

  List<Map<String, String>> createRecommendArr(List<Meals> mealsList) {
    List<Map<String, String>> recommendArr = [];
    var icons = {
      "Pancake": "assets/img/rd_1.png",
      "Bread": "assets/img/m_4.png",
      "Honey Pancake": "assets/img/rd_1.png",
      "Canai Bread": "assets/img/m_4.png",
      "Salmon Nigiri": "assets/img/f_2.png",
      "Blueberry Pancake": "assets/img/f_1.png",
      "Salad": "assets/img/salad.png",
      "Milk": "assets/img/m_2.png",
      "Pie": "assets/img/m_3.png",
    };
    for (var meal in mealsList) {
      recommendArr.add({
        "name": meal.name,
        "image": icons.containsKey(meal.name) ? icons[meal.name]! : meal.icon,
        "kcal": "${meal.calories}kCal",
      });
    }

    return recommendArr;
  }

  bool _isLoading = true;

  List<Meals> meals = [];
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<MealProvider>(context, listen: false).fetchMeals();
      meals = Provider.of<MealProvider>(context, listen: false).meals;
      popularArr = meals
          .where((meal) => meal.mealType.customName == widget.eObj["name"])
          .map((meal) {
        return {
          "name": meal.name,
          "image": meal.icon,
          "b_image": meal.icon.replaceFirst(".png", "_high.png"),
          "kcal": "${meal.calories}kCal",
          "meal": meal,
        };
      }).toList();
      recommendArr = createRecommendArr(meals);
      setState(() {
        _isLoading = false;
      });
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
            widget.eObj["name"].toString(),
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
          widget.eObj["name"].toString(),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 20),
            //   padding: const EdgeInsets.symmetric(horizontal: 8),
            //   decoration: BoxDecoration(
            //       color: TColor.white,
            //       borderRadius: BorderRadius.circular(15),
            //       boxShadow: const [
            //         BoxShadow(
            //             color: Colors.black12,
            //             blurRadius: 2,
            //             offset: Offset(0, 1))
            //       ]),
            //   child: Row(
            //     children: [
            //       Expanded(
            //           child: TextField(
            //         controller: txtSearch,
            //         decoration: InputDecoration(
            //             focusedBorder: InputBorder.none,
            //             enabledBorder: InputBorder.none,
            //             prefixIcon: Image.asset(
            //               "assets/img/search.png",
            //               width: 25,
            //               height: 25,
            //             ),
            //             hintText: "Search Pancake"),
            //       )),
            //       Container(
            //         margin: const EdgeInsets.symmetric(horizontal: 8),
            //         width: 1,
            //         height: 25,
            //         color: TColor.gray.withOpacity(0.3),
            //       ),
            //       InkWell(
            //         onTap: () {},
            //         child: Image.asset(
            //           "assets/img/Filter.png",
            //           width: 25,
            //           height: 25,
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: media.width * 0.05,
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         "Category",
            //         style: TextStyle(
            //             color: TColor.black,
            //             fontSize: 16,
            //             fontWeight: FontWeight.w700),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: 120,
            //   child: ListView.builder(
            //       padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //       scrollDirection: Axis.horizontal,
            //       itemCount: categoryArr.length,
            //       itemBuilder: (context, index) {
            //         var cObj = categoryArr[index] as Map? ?? {};
            //         return MealCategoryCell(
            //           cObj: cObj,
            //           index: index,
            //         );
            //       }),
            // ),
            SizedBox(
              height: media.width * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Recommendation\nfor Diet",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: media.width * 0.6,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendArr.length,
                  itemBuilder: (context, index) {
                    var fObj = recommendArr[index] as Map? ?? {};
                    return MealRecommendCell(
                      fObj: fObj,
                      index: index,
                    );
                  }),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Popular",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
            ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: popularArr.length,
                itemBuilder: (context, index) {
                  var fObj = popularArr[index] as Map? ?? {};
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FoodInfoDetailsView(
                            dObj: fObj,
                            mObj: widget.eObj,
                          ),
                        ),
                      );
                    },
                    child: PopularMealRow(
                      mObj: fObj,
                    ),
                  );
                }),
            SizedBox(
              height: media.width * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
