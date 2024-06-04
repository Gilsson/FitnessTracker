import 'package:fitness_sync/application/providers/auth_provider.dart';
import 'package:fitness_sync/application/providers/today_target_provider.dart';
import 'package:fitness_sync/application/providers/user_health_provider.dart';
import 'package:fitness_sync/application/providers/user_provider.dart';
import 'package:fitness_sync/application/providers/user_stats_provider.dart';
import 'package:fitness_sync/common/color_extension.dart';
import 'package:fitness_sync/common_widget/latest_activity_row.dart';
import 'package:fitness_sync/common_widget/today_target_cell.dart';
import 'package:fitness_sync/domain/entities/data/calories_target.dart';
import 'package:fitness_sync/domain/entities/data/notification.dart';
import 'package:fitness_sync/domain/entities/data/reminder.dart';
import 'package:fitness_sync/domain/entities/data/sleep_data.dart';
import 'package:fitness_sync/domain/entities/data/step_data.dart';
import 'package:fitness_sync/domain/entities/meals/meals.dart';
import 'package:fitness_sync/domain/entities/water/water.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ActivityTrackerView extends StatefulWidget {
  const ActivityTrackerView({super.key});

  @override
  State<ActivityTrackerView> createState() => _ActivityTrackerViewState();
}

class _ActivityTrackerViewState extends State<ActivityTrackerView> {
  int touchedIndex = -1;
  bool _isLoading = true;
  List latestArr = [
    {
      "image": "assets/img/pic_4.png",
      "title": "Drinking 300ml Water",
      "time": "About 1 minutes ago"
    },
    {
      "image": "assets/img/pic_5.png",
      "title": "Eat Snack (Fitbar)",
      "time": "About 3 hours ago"
    },
  ];

  SleepData? todaySleepData;
  StepData? todayStepData;
  Water? todayWaterData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      String userId =
          Provider.of<AuthenticationProvider>(context, listen: false).userId!;
      Provider.of<UserProvider>(context, listen: false).fetchUser(userId);
      final targetProvider =
          Provider.of<TodayTargetProvider>(context, listen: false);

      await targetProvider.fetchTargets(userId);
      await targetProvider.fetchWeekGoals(userId);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
            "Activity Tracker",
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
    var authProvider = Provider.of<AuthenticationProvider>(context);
    var todayTargetProvider = Provider.of<TodayTargetProvider>(context);
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
          "Activity Tracker",
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
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    TColor.primaryColor2.withOpacity(0.3),
                    TColor.primaryColor1.withOpacity(0.3)
                  ]),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today Target",
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TodayTargetCell(
                            icon: "assets/img/water.png",
                            value: todayTargetProvider.waterTargets.isEmpty
                                ? "0L"
                                : (todayTargetProvider.waterTargets.last.amount
                                                .toDouble() /
                                            1000.0)
                                        .toStringAsFixed(1) +
                                    "L",
                            title: "Water Intake",
                            onTap: () => _showSliderDialog(
                                context, "Water Intake", "ml"),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TodayTargetCell(
                            icon: "assets/img/foot.png",
                            value: todayTargetProvider.stepTargets.isEmpty
                                ? "10000"
                                : (todayTargetProvider.stepTargets.last.steps)
                                    .toString(),
                            title: "Foot Steps",
                            onTap: () => _showSliderDialog(
                                context, "Foot Steps", "steps"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TodayTargetCell(
                            icon: "assets/img/bed.png",
                            value: todayTargetProvider.sleepTargets.isEmpty
                                ? "8h"
                                : (todayTargetProvider
                                            .sleepTargets.last.duration.inHours)
                                        .toString() +
                                    ' hours',
                            title: "Sleep",
                            onTap: () =>
                                _showSliderDialog(context, "Sleep", "hours"),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TodayTargetCell(
                            icon: "assets/img/salad.png",
                            value: todayTargetProvider.caloriesTargets.isEmpty
                                ? "2000"
                                : (todayTargetProvider
                                        .caloriesTargets.last.calories)
                                    .toString(),
                            title: "Calories",
                            onTap: () => _showSliderDialog(
                                context, "Calories", "calories"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: media.width * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Activity Progress",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  //   Container(
                  //       height: 30,
                  //       padding: const EdgeInsets.symmetric(horizontal: 8),
                  //       decoration: BoxDecoration(
                  //         gradient: LinearGradient(colors: TColor.primaryG),
                  //         borderRadius: BorderRadius.circular(15),
                  //       ),
                  //       child: DropdownButtonHideUnderline(
                  //         child: DropdownButton(
                  //           items: ["Weekly", "Monthly"]
                  //               .map((name) => DropdownMenuItem(
                  //                     value: name,
                  //                     child: Text(
                  //                       name,
                  //                       style: TextStyle(
                  //                           color: TColor.gray, fontSize: 14),
                  //                     ),
                  //                   ))
                  //               .toList(),
                  //           onChanged: (value) {},
                  //           icon: Icon(Icons.expand_more, color: TColor.white),
                  //           hint: Text(
                  //             "Weekly",
                  //             textAlign: TextAlign.center,
                  //             style: TextStyle(color: TColor.white, fontSize: 12),
                  //           ),
                  //         ),
                  //       )),
                ],
              ),
              SizedBox(
                height: media.width * 0.05,
              ),
              Container(
                height: media.width * 0.5,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 3)
                    ]),
                child: BarChart(BarChartData(
                  //   maxY: 500,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      fitInsideVertically:
                          true, // Ensure the tooltip fits inside vertically
                      fitInsideHorizontally: true,
                      getTooltipColor: (BarChartGroupData group) => Colors.grey,
                      tooltipHorizontalAlignment: FLHorizontalAlignment.center,
                      tooltipMargin: 20,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String weekDay;
                        switch (group.x) {
                          case 0:
                            weekDay = 'Monday';
                            break;
                          case 1:
                            weekDay = 'Tuesday';
                            break;
                          case 2:
                            weekDay = 'Wednesday';
                            break;
                          case 3:
                            weekDay = 'Thursday';
                            break;
                          case 4:
                            weekDay = 'Friday';
                            break;
                          case 5:
                            weekDay = 'Saturday';
                            break;
                          case 6:
                            weekDay = 'Sunday';
                            break;
                          default:
                            throw Error();
                        }
                        return BarTooltipItem(
                          '$weekDay\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ("Sleep: " +
                                      todayTargetProvider.sleep[group.x]
                                          .toString() +
                                      " h\n" +
                                      "Steps: " +
                                      todayTargetProvider.step[group.x]
                                          .toString() +
                                      " steps\n" +
                                      "Water: " +
                                      (todayTargetProvider.water[group.x]
                                                  .toDouble() /
                                              1000)
                                          .toStringAsFixed(1) +
                                      " L\n" +
                                      "Calories: " +
                                      todayTargetProvider.calories[group.x]
                                          .toString())
                                  .toString(),
                              style: TextStyle(
                                color: TColor.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    touchCallback: (FlTouchEvent event, barTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            barTouchResponse == null ||
                            barTouchResponse.spot == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex =
                            barTouchResponse.spot!.touchedBarGroupIndex;
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: getTitles,
                        reservedSize: 38,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingGroups(),
                  maxY: 100,
                  gridData: FlGridData(show: false),
                )),
              ),
              SizedBox(
                height: media.width * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Latest Workout",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "See More",
                      style: TextStyle(
                          color: TColor.gray,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
              ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: latestArr.length,
                  itemBuilder: (context, index) {
                    var wObj = latestArr[index] as Map? ?? {};
                    return LatestActivityRow(wObj: wObj);
                  }),
              SizedBox(
                height: media.width * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    var style = TextStyle(
      color: TColor.gray,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );
    var today = DateTime.now().weekday;
    var map = {
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7: 'Sun'
    };
    int dayToShow = today - (6 - value.toInt());
    if (dayToShow < 1) {
      dayToShow += 7; // Wrap around if the value goes below 1 (Monday)
    }

    Widget text = Text(map[dayToShow]!, style: style);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  List<BarChartGroupData> showingGroups() {
    var today = DateTime.now().weekday;
    var todayTargetProvider = Provider.of<TodayTargetProvider>(context);
    String userId = Provider.of<AuthenticationProvider>(context).userId!;
    var listActivity = todayTargetProvider.targetsList;
    return List.generate(7, (i) {
      return makeGroupData(i, listActivity[i] * 100,
          i % 2 == 0 ? TColor.primaryG : TColor.secondaryG,
          isTouched: i == touchedIndex);
    });
  }

  void _showSliderDialog(BuildContext context, String title, String unit) {
    double _currentValue = 0;
    Function? onChange;
    var max = 0.0;
    var divisions = 0;
    switch (unit) {
      case "hours":
        max = 12.0;
        divisions = 12;
        onChange = (double value, provider, userId) {
          return provider.addTargetSleep(
              userId,
              SleepData(
                  date: DateTime.now(),
                  duration: Duration(hours: value.toInt()),
                  sleepStage: SleepStage.planned));
        };
        break;
      case "steps":
        max = 50000.0;
        divisions = max ~/ 1000;
        onChange = (double value, provider, userId) {
          return provider.addTargetStep(
              userId,
              StepData(
                steps: value.toInt(),
                date: DateTime.now(),
                duration: Duration.zero,
                isScheduled: true,
              ));
        };
        break;
      case "ml":
        max = 4000.0;
        divisions = max ~/ 100;
        onChange = (double value, provider, userId) {
          return provider.addTargetWater(
              userId,
              Water(
                amount: value.toInt(),
                dateTaken: DateTime.now(),
                isScheduled: true,
              ));
        };
        break;
      case "calories":
        max = 6000.0;
        divisions = max ~/ 200;
        onChange = (double value, provider, userId) {
          return provider.addTargetCalories(
              userId,
              CaloriesTarget.now(
                calories: value.toInt(),
              ));
        };
        break;
      default:
        max = 10.0;
        divisions = 1;
        break;
    }
    showDialog(
      context: context,
      builder: (context) {
        final todayTargetProvider = Provider.of<TodayTargetProvider>(context);
        final userId = Provider.of<AuthenticationProvider>(context).userId!;
        return AlertDialog(
          title: Text("Set $title"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Slider(
                    value: _currentValue,
                    min: 0,
                    max: max,
                    divisions: divisions,
                    label: "${_currentValue.round()} $unit",
                    onChanged: (value) {
                      setState(() {
                        _currentValue = value;
                      });
                    },
                  ),
                  Text(
                    "${_currentValue.round()} $unit",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Handle the saving of the selected value here
                setState(() => _isLoading = true);
                await onChange!(_currentValue, todayTargetProvider, userId);
                await todayTargetProvider.fetchWeekGoals(userId);
                setState(
                  () => _isLoading = false,
                );
                Navigator.of(context).pop();
                // Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content:
              Text('Please enter valid numeric values or leave fields empty.'),
          actions: <Widget>[
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

  BarChartGroupData makeGroupData(
    int x,
    double y,
    List<Color> barColor, {
    bool isTouched = false,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          gradient: LinearGradient(
              colors: barColor,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          width: width,
          borderSide: isTouched
              ? const BorderSide(color: Colors.green)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: TColor.lightGray,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}
