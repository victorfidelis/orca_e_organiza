import 'package:flutter/material.dart';
import 'package:orca_e_organiza/core/themes/themes.dart';

class TextButtomFormat extends StatelessWidget {
  String label;
  Function() onPressed;

  TextButtomFormat({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: buttomPrimaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: buttomTertiaryColor,
          ),
        ),
      ),
    );
  }
}
