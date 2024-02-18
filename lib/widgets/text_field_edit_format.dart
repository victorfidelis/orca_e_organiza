import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldEditFormat extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final String? errorText;

  const TextFieldEditFormat({
    super.key,
    this.label,
    this.controller,
    this.errorText,
  });

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
