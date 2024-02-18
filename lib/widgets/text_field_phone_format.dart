import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldPhoneFormat extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? errorText;

  const TextFieldPhoneFormat({
    super.key,
    required this.label,
    required this.controller,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: FocusScope(
        onFocusChange: (value) {
          if (value) selectedField(controller);
        },
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            label: Text(label),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(),
            errorText: errorText,
            hintText: '(99) 99999-9999'
          ),
          keyboardType: const TextInputType.numberWithOptions(
            signed: false,
            decimal: true,
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(15)
          ],
        ),
      ),
    );
  }

  void selectedField(TextEditingController controller) {
    controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
  }
}
