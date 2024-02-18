import 'package:flutter/material.dart';

class TextButtonBottomSheet extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final Icon icon;
  final Function() onPressed;

  const TextButtonBottomSheet({
    super.key,
    required this.text,
    required this.color,
    required this.textColor,
    required this.icon,
    required this.onPressed,
  });

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
