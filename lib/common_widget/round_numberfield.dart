import 'package:fitness_sync/common/color_extension.dart';
import 'package:flutter/material.dart';

class RoundNumberField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String icon;

  const RoundNumberField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
  }) : super(key: key);

  @override
  _RoundNumberFieldState createState() => _RoundNumberFieldState();
}

class _RoundNumberFieldState extends State<RoundNumberField> {
  void _showNumberDialog() async {
    int? number = await showDialog(
      context: context,
      builder: (BuildContext context) {
        int tempNumber = int.tryParse(widget.controller.text) ?? 0;
        return AlertDialog(
          title: Text('Enter a number'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              tempNumber = int.tryParse(value) ?? 0;
            },
            decoration: InputDecoration(hintText: 'Positive integer'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, tempNumber),
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    if (number != null && number > 0) {
      setState(() {
        widget.controller.text = number.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showNumberDialog,
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
