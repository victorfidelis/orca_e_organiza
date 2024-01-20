import 'package:flutter/material.dart';

class LineDoubleTextLink extends StatelessWidget {
  String label;
  String value;
  Function(String) openLink;

  LineDoubleTextLink({
    Key? key,
    required this.label,
    required this.value,
    required this.openLink,
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
        Expanded(
          child: GestureDetector(
            onTap: () {
              openLink(value);
            },
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xff0000EE),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}
