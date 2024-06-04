import 'package:fitness_sync/common/color_extension.dart';
import 'package:flutter/material.dart';

class WorkoutSelectionCell extends StatelessWidget {
  final String icon;
  final String name;
  final String duration;
  final String difficulty;
  final Function onTap;

  const WorkoutSelectionCell({
    Key? key,
    required this.icon,
    required this.name,
    required this.duration,
    required this.difficulty,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: TColor.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Duration: $duration | Difficulty: $difficulty',
                    style: TextStyle(
                      color: TColor.black.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
