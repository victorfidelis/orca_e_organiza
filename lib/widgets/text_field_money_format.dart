import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldMoneyFormat extends StatelessWidget {
  String label;
  TextEditingController controller;
  String? errorText;

  TextFieldMoneyFormat({
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
            prefixText: 'R\$ ',
          ),
          keyboardType: const TextInputType.numberWithOptions(
            signed: false,
            decimal: true,
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(18)
          ],
        ),
      ),
    );
  }

  void selectedField(TextEditingController controller) {
    controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
  }
}
