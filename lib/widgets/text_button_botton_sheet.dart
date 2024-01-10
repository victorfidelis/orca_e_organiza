import 'package:flutter/material.dart';

class TextButtonBottomSheet extends StatelessWidget {
  String text;
  Color color;
  Color textColor;
  Icon icon;
  Function() onPressed;

  TextButtonBottomSheet({
    Key? key,
    required this.text,
    required this.color,
    required this.textColor,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
