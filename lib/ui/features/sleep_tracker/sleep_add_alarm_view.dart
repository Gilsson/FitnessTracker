import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:fitness_sync/application/providers/auth_provider.dart';
import 'package:fitness_sync/application/providers/user_health_provider.dart';
import 'package:fitness_sync/common/color_extension.dart';
import 'package:fitness_sync/common/common.dart';
import 'package:fitness_sync/common_widget/icon_title_next_row.dart';
import 'package:fitness_sync/common_widget/round_button.dart';
import 'package:fitness_sync/domain/entities/data/sleep_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SleepAddAlarmView extends StatefulWidget {
  final DateTime date;
  const SleepAddAlarmView({super.key, required this.date});

  @override
  State<SleepAddAlarmView> createState() => _SleepAddAlarmViewState();
}

class _SleepAddAlarmViewState extends State<SleepAddAlarmView> {
  bool positive = false;
  DateTime? bedTime;
  DateTime? raiseTime;
  DateTime? selectedDate;
  String userId = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isLoading = true;
      });
      bedTime = widget.date;
      raiseTime = widget.date.add(Duration(hours: 8, minutes: 30));
      selectedDate = widget.date;
      userId =
          Provider.of<AuthenticationProvider>(context, listen: false).userId!;
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: selectedDate!,
      lastDate: selectedDate!.add(Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showCupertinoDatePicker(
      Function(DateTime) onDateTimeChanged, DateTime initialDate) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 255,
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            Container(
              height: 200,
              child: CupertinoDatePicker(
                initialDateTime: initialDate,
                minimumDate: DateTime(
                    selectedDate!.year, selectedDate!.month, selectedDate!.day),
                maximumDate: selectedDate!.add(Duration(days: 30)),
                onDateTimeChanged: onDateTimeChanged,
                use24hFormat: true,
                mode: CupertinoDatePickerMode.dateAndTime,
              ),
            ),
            CupertinoButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading ||
        selectedDate == null ||
        bedTime == null ||
        raiseTime == null) {
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
            "Add alarm",
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
              "assets/img/closed_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Add Alarm",
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
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 8,
          ),
          IconTitleNextRow(
            icon: "assets/img/Bed_Add.png",
            title: "Bedtime",
            time: "${formatTo12Hour(bedTime!)}",
            color: TColor.lightGray,
            onPressed: () {
              _showCupertinoDatePicker((dateTime) {
                setState(() {
                  bedTime = dateTime;
                });
              }, bedTime!);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          IconTitleNextRow(
            icon: "assets/img/HoursTime.png",
            title: "Raise Time",
            time: "${formatTo12Hour(raiseTime!)}",
            color: TColor.lightGray,
            onPressed: () {
              _showCupertinoDatePicker((dateTime) {
                setState(() {
                  raiseTime = dateTime;
                });
              }, raiseTime!);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
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
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  //         title: "Learn More", fontSize: 12, onPressed: () {}),
                  //   )
                ]),
                Image.asset(
                  "assets/img/sleep_schedule.png",
                  width: media.width * 0.35,
                )
              ],
            ),
          ),
          //   const SizedBox(
          //     height: 10,
          //   ),
          //   IconTitleNextRow(
          //     icon: "assets/img/Repeat.png",
          //     title: "Select Date",
          //     time: "${selectedDate!.toLocal()}".split(' ')[0],
          //     color: TColor.lightGray,
          //     onPressed: () {
          //       _selectDate(context);
          //     },
          //   ),
          const SizedBox(
            height: 10,
          ),
          const Spacer(),
          RoundButton(
              title: "Add",
              onPressed: () async {
                if (raiseTime!.isBefore(bedTime!)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Raise time cannot be before bedtime. Please adjust the times.'),
                      backgroundColor: TColor.primaryColor1,
                      showCloseIcon: true,
                      closeIconColor: TColor.white,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else {
                  await Provider.of<UserHealthProvider>(context, listen: false)
                      .addSleep(
                          userId,
                          SleepData(
                              date: bedTime!,
                              duration: raiseTime!.difference(bedTime!),
                              sleepStage: SleepStage.planned));
                  Navigator.pop(context);
                }
              }),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }
}
