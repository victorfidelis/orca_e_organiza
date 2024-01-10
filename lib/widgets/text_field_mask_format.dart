import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:extended_masked_text/extended_masked_text.dart';

class TextFieldMaskFormat extends StatelessWidget {
  String? label;
  MaskedTextController? controller;
  String? errorText;
  bool isNumeric;

  TextFieldMaskFormat({
    Key? key,
    this.label,
    this.controller,
    this.errorText,
    this.isNumeric = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(label ?? ''),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(),
        errorText: errorText,
      ),
      keyboardType: isNumeric ? TextInputType.number : null,
    );
  }
}
