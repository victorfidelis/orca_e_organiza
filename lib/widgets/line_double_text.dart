import 'package:flutter/material.dart';

class LineDoubleText extends StatelessWidget {
  String label;
  String value;

  LineDoubleText({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          softWrap: true,
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
