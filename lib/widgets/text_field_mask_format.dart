import 'package:flutter/material.dart';
import 'package:extended_masked_text/extended_masked_text.dart';

class TextFieldMaskFormat extends StatelessWidget {
  final String? label;
  final MaskedTextController? controller;
  final String? errorText;
  final bool isNumeric;

  const TextFieldMaskFormat({
    super.key,
    this.label,
    this.controller,
    this.errorText,
    this.isNumeric = false,
  });

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
