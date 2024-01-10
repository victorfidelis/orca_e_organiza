import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UtilsService {
  static void showSnackBarFormat(
    ScaffoldMessengerState scaffoldMessengerState,
    String content,
  ) {
    SnackBar snackBar = SnackBar(
      content: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: const Color(0xee000000),
      duration: const Duration(seconds: 1),
    );
    scaffoldMessengerState.showSnackBar(snackBar);
  }
}

final NumberFormat formatterMoney = NumberFormat("###,###,###,##0.00", 'pt_BR');
