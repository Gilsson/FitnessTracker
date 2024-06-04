import 'package:fitness_sync/application/providers/auth_provider.dart';
import 'package:fitness_sync/application/providers/user_workout_provider.dart';
import 'package:fitness_sync/common/color_extension.dart';
import 'package:fitness_sync/common/common.dart';
import 'package:fitness_sync/common_widget/icon_title_next_row.dart';
import 'package:fitness_sync/common_widget/round_button.dart';
import 'package:fitness_sync/domain/entities/data/exercise.dart';
import 'package:fitness_sync/domain/entities/data/workout.dart';
import 'package:fitness_sync/ui/features/workout_tracker/workout_selection_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddScheduleView extends StatefulWidget {
  final DateTime date;
  const AddScheduleView({super.key, required this.date});

  @override
  State<AddScheduleView> createState() => _AddScheduleViewState();
}

class _AddScheduleViewState extends State<AddScheduleView> {
  Workout? selectedWorkout;
  DateTime selectedDateTime = DateTime.now();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userWorkoutProvider =
          Provider.of<UserWorkoutProvider>(context, listen: false);
      var userId =
          Provider.of<AuthenticationProvider>(context, listen: false).userId!;
      await userWorkoutProvider.fetchUserWorkouts(userId);
    });
  }

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
  }

  @override
  Widget build(BuildContext context) {
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
          "Add Schedule",
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
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left),
                onPressed: () => _changeDate(-1),
              ),
              Image.asset(
                "assets/img/date.png",
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 8),
              Text(
                dateToString(selectedDate, formatStr: "E, dd MMMM yyyy"),
                style: TextStyle(color: TColor.gray, fontSize: 14),
              ),
              IconButton(
                icon: Icon(Icons.arrow_right),
                onPressed: () => _changeDate(1),
              ),
              //   Image.asset(
              //     "assets/img/date.png",
              //     width: 20,
              //     height: 20,
              //   ),
              //   const SizedBox(
              //     width: 8,
              //   ),
              //   Text(
              //     dateToString(widget.date, formatStr: "E, dd MMMM yyyy"),
              //     style: TextStyle(color: TColor.gray, fontSize: 14),
              //   ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Time",
            style: TextStyle(
                color: TColor.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: media.width * 0.35,
            child: CupertinoDatePicker(
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  selectedDateTime = newDateTime;
                });
              },
              initialDateTime: selectedDate,
              use24hFormat: false,
              minuteInterval: 1,
              mode: CupertinoDatePickerMode.time,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Details Workout",
            style: TextStyle(
                color: TColor.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 8,
          ),
          IconTitleNextRow(
              icon: "assets/img/choose_workout.png",
              title: "Choose Workout",
              time: selectedWorkout == null ? "Nothing" : selectedWorkout!.name,
              color: TColor.lightGray,
              onPressed: () async {
                final Workout? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutSelectionScreen(),
                  ),
                );

                if (result != null) {
                  setState(() {
                    selectedWorkout = result;
                  });
                }
              }),
          const SizedBox(
            height: 10,
          ),
          IconTitleNextRow(
              icon: "assets/img/difficulity.png",
              title: "Difficulity",
              time: selectedWorkout == null
                  ? "Nothing"
                  : selectedWorkout!.difficulty.customName,
              color: TColor.lightGray,
              onPressed: () {}),
          const SizedBox(
            height: 10,
          ),
          Spacer(),
          RoundButton(
              title: "Save",
              onPressed: () async {
                if (selectedWorkout == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select a workout before saving.'),
                    ),
                  );
                } else {
                  selectedDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedDateTime.hour,
                      selectedDateTime.minute);

                  await Provider.of<UserWorkoutProvider>(context, listen: false)
                      .scheduleWorkout(
                    Provider.of<AuthenticationProvider>(context, listen: false)
                        .userId!,
                    selectedWorkout!,
                    selectedDateTime,
                  );
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
