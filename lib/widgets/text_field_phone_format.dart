import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldPhoneFormat extends StatelessWidget {
  String label;
  TextEditingController controller;
  String? errorText;

  TextFieldPhoneFormat({
    Key? key,
    required this.label,
    required this.controller,
    this.errorText,
  }) : super(key: key);

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
            label: Text(label ?? ''),
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
