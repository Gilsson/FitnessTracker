import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:fitness_sync/application/providers/auth_provider.dart';
import 'package:fitness_sync/application/providers/user_health_provider.dart';
import 'package:fitness_sync/common/color_extension.dart';
import 'package:fitness_sync/common/common.dart';
import 'package:fitness_sync/common_widget/round_button.dart';
import 'package:fitness_sync/common_widget/today_sleep_schedule_row.dart';
import 'package:fitness_sync/domain/entities/data/sleep_data.dart';
import 'package:fitness_sync/ui/features/sleep_tracker/sleep_add_alarm_view.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

class SleepScheduleView extends StatefulWidget {
  const SleepScheduleView({super.key});

  @override
  State<SleepScheduleView> createState() => _SleepScheduleViewState();
}

class _SleepScheduleViewState extends State<SleepScheduleView> {
  CalendarAgendaController _calendarAgendaControllerAppBar =
      CalendarAgendaController();
  late DateTime _selectedDateAppBBar;

  List todaySleepArr = [
    // {
    //   "name": "Bedtime",
    //   "image": "assets/img/bed.png",
    //   "time": "01/06/2023 09:00 PM",
    //   "duration": "in 6hours 22minutes"
    // },
    // {
    //   "name": "Alarm",
    //   "image": "assets/img/alaarm.png",
    //   "time": "02/06/2023 05:10 AM",
    //   "duration": "in 14hours 30minutes"
    // },
  ];

  List<int> showingTooltipOnSpots = [4];
  List<SleepData> sleepDataList = [];
  Duration sleepDuration = Duration.zero;
  bool _isLoading = true;
  String userId = "";

  Future<void> setTodayArrSleep() async {
    sleepDuration = Duration.zero;
    await Provider.of<UserHealthProvider>(context, listen: false)
        .fetchUserSleepDate(userId, _selectedDateAppBBar);
    sleepDataList = Provider.of<UserHealthProvider>(context, listen: false)
        .sleep
        .where((data) =>
            data.isScheduled &&
            data.date.day == _selectedDateAppBBar.day &&
            data.date.month == _selectedDateAppBBar.month &&
            data.date.year == _selectedDateAppBBar.year)
        .toList();
    todaySleepArr = sleepDataList.map((sleepData) {
      String name =
          sleepData.sleepStage == SleepStage.planned ? 'Bedtime' : 'Alarm';
      String image = sleepData.sleepStage == SleepStage.planned
          ? 'assets/img/bed.png'
          : 'assets/img/alaarm.png';
      String time =
          "${sleepData.date.day.toString().padLeft(2, '0')}/${sleepData.date.month.toString().padLeft(2, '0')}/${sleepData.date.year} ${dateToString(sleepData.date, formatStr: "E hh:mm a")}";
      String duration =
          "${sleepData.duration.inHours} hours ${sleepData.duration.inMinutes.remainder(60)} minutes";
      String raiseTime = dateToString(sleepData.date.add(sleepData.duration),
          formatStr: "E hh:mm a");
      return {
        "name": name,
        "image": image,
        "time": time,
        "duration": duration,
        "raiseTime": raiseTime
      };
    }).toList();
    if (sleepDataList.isNotEmpty) {
      sleepDuration = sleepDataList
          .map((sleepData) => sleepData.duration)
          .reduce((value, element) => value + element);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (context.mounted) {
        setState(() => _isLoading = true);
        setState(() => _selectedDateAppBBar = DateTime.now());
        userId =
            await Provider.of<AuthenticationProvider>(context, listen: false)
                .userId!;
        await setTodayArrSleep();
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
            "Sleep Schedule",
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
          "Sleep Schedule",
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(20),
                    height: media.width * 0.4,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          TColor.primaryColor2.withOpacity(0.4),
                          TColor.primaryColor1.withOpacity(0.4)
                        ]),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Ideal Hours for Sleep",
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "8hours 30minutes",
                                style: TextStyle(
                                    color: TColor.primaryColor2,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              //   SizedBox(
                              //     width: 110,
                              //     height: 35,
                              //     child: RoundButton(
                              //         title: "Learn More",
                              //         fontSize: 12,
                              //         onPressed: () {}),
                              //   )
                            ]),
                        Image.asset(
                          "assets/img/sleep_schedule.png",
                          width: media.width * 0.35,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    "Your Schedule",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                CalendarAgenda(
                  controller: _calendarAgendaControllerAppBar,
                  appbar: false,
                  selectedDayPosition: SelectedDayPosition.center,
                  //   leading: IconButton(
                  //       onPressed: () {},
                  //       icon: Image.asset(
                  //         "assets/img/ArrowLeft.png",
                  //         width: 15,
                  //         height: 15,
                  //       )),
                  //   training: IconButton(
                  //       onPressed: () {},
                  //       icon: Image.asset(
                  //         "assets/img/ArrowRight.png",
                  //         width: 15,
                  //         height: 15,
                  //       )),
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
                    setState(() => _isLoading = true);
                    setState(() => _selectedDateAppBBar = date);

                    await setTodayArrSleep();
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
                SizedBox(
                  height: media.width * 0.03,
                ),
                ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: todaySleepArr.length,
                    itemBuilder: (context, index) {
                      var sObj = todaySleepArr[index] as Map? ?? {};
                      return TodaySleepScheduleRow(
                        sObj: sObj,
                      );
                    }),
                Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          TColor.secondaryColor2.withOpacity(0.4),
                          TColor.secondaryColor1.withOpacity(0.4)
                        ]),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "You will get ${sleepDuration.inHours} hours ${sleepDuration.inMinutes.remainder(60)} minutes\nfor tonight",
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SimpleAnimationProgressBar(
                              height: 15,
                              width: media.width - 80,
                              backgroundColor: Colors.grey.shade100,
                              foregrondColor: Colors.purple,
                              ratio: ((sleepDuration.inMinutes.toDouble() /
                                          Duration(hours: 8, minutes: 30)
                                              .inMinutes
                                              .toDouble())
                                      .clamp(0.0, 1.0) *
                                  100.0),
                              direction: Axis.horizontal,
                              curve: Curves.fastLinearToSlowEaseIn,
                              duration: const Duration(seconds: 3),
                              borderRadius: BorderRadius.circular(7.5),
                              gradientColor: LinearGradient(
                                  colors: TColor.secondaryG,
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                            ),
                            Text(
                              "${((sleepDuration.inMinutes.toDouble() / Duration(hours: 8, minutes: 30).inMinutes.toDouble()).clamp(0.0, 1.0) * 100.0).toStringAsFixed(0)}%",
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SleepAddAlarmView(
                date: _selectedDateAppBBar,
              ),
            ),
          );
        },
        child: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: TColor.secondaryG),
              borderRadius: BorderRadius.circular(27.5),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))
              ]),
          alignment: Alignment.center,
          child: Icon(
            Icons.add,
            size: 20,
            color: TColor.white,
          ),
        ),
      ),
    );
  }
}
