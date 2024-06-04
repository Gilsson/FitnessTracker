import 'package:fitness_sync/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Make sure to add intl package to your pubspec.yaml

class RoundDateField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String icon;

  const RoundDateField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
  }) : super(key: key);

  @override
  _RoundDateFieldState createState() => _RoundDateFieldState();
}

class _RoundDateFieldState extends State<RoundDateField> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        widget.controller.text = pickedDate.toIso8601String();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        decoration: BoxDecoration(
          color: TColor.lightGray,
          borderRadius: BorderRadius.circular(15),
        ),
        child: AbsorbPointer(
          child: TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: widget.hintText,
              prefixIcon: Container(
                alignment: Alignment.center,
                width: 20,
                height: 20,
                child: Image.asset(
                  widget.icon,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  color: TColor.gray,
                ),
              ),
              hintStyle: TextStyle(color: TColor.gray, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}
