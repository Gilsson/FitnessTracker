import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:fitness_sync/application/providers/user_workout_provider.dart';
import 'package:fitness_sync/common/color_extension.dart';
import 'package:fitness_sync/domain/entities/data/workout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpcomingWorkoutRow extends StatefulWidget {
  final Map wObj;
  const UpcomingWorkoutRow({super.key, required this.wObj});

  @override
  State<UpcomingWorkoutRow> createState() => _UpcomingWorkoutRowState();
}

class _UpcomingWorkoutRowState extends State<UpcomingWorkoutRow> {
  bool positive = false;
  bool isCompleted = false;

  Future<void> toggleCompletion() async {
    setState(() {
      isCompleted = !isCompleted;
    });
    if (isCompleted) {
      await Provider.of<UserWorkoutProvider>(context, listen: false)
          .markAsCompleted(widget.wObj["workout"] as UserWorkout);
    } else {
      await Provider.of<UserWorkoutProvider>(context, listen: false)
          .markAsNotCompleted(widget.wObj["workout"] as UserWorkout);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              widget.wObj["image"].toString(),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.wObj["title"].toString(),
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  widget.wObj["time"].toString(),
                  style: TextStyle(
                    color: TColor.gray,
                    fontSize: 10,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: toggleCompletion,
            style: TextButton.styleFrom(
              backgroundColor:
                  isCompleted ? TColor.primaryColor2 : TColor.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(isCompleted ? 'Completed' : 'Complete'),
          ),
        ],
      ),
    );
  }
}
