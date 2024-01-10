import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldFormat extends StatelessWidget {
  String? label;
  TextEditingController? controller;
  String? errorText;
  bool isNumeric;

  TextFieldFormat({
    Key? key,
    this.label,
    this.controller,
    this.errorText,
    this.isNumeric = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          label: Text(label ?? ''),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(),
          errorText: errorText,
        ),
        keyboardType: isNumeric ? TextInputType.number : null,
      ),
    );
  }
}
