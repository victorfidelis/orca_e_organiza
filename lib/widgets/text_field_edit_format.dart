import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldEditFormat extends StatelessWidget {
  String? label;
  TextEditingController? controller;
  String? errorText;

  TextFieldEditFormat({
    Key? key,
    this.label,
    this.controller,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: TextField(
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.top,
        controller: controller,
        decoration: InputDecoration(
          label: Text(label ?? ''),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(),
          errorText: errorText,
          isDense: true,
        ),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        expands: true,
      ),
    );
  }
}
