import 'package:fitness_sync/common/color_extension.dart';
import 'package:flutter/material.dart';

class WorkoutListCell extends StatelessWidget {
  final String icon;
  final String name;
  final String duration;
  final String difficulty;
  final VoidCallback onTap;

  const WorkoutListCell({
    Key? key,
    required this.icon,
    required this.name,
    required this.duration,
    required this.difficulty,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            TColor.primaryColor1,
            Colors.blueAccent.withOpacity(0.3),
          ]),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
                Image.asset(
                  icon,
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Duration: $duration",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  "Difficulty: $difficulty",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
