import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class TextFieldDateFormat extends StatelessWidget {
  final String? label;
  final TextEditingController controller;
  final String? errorText;
  DateTime? dateValue = DateTime.now();

  TextFieldDateFormat({
    super.key,
    required this.controller,
    this.label,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {

    if (controller.text.isNotEmpty) {
      dateValue = DateFormat('dd/MM/yyyy').parse(controller.text);
    }

    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        label: Text(label ?? ''),
        suffixIcon: const Icon(Icons.event_note),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(),
        errorText: errorText,
      ),
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: dateValue,
          firstDate: DateTime(2018, 1, 1),
          lastDate: DateTime(2050, 12, 31),
        ).then((value) {
          if (value != null) {
            dateValue = value;
            controller.text = DateFormat('dd/MM/yyyy').format(value);
          }
        });
      },
    );
  }
}
