import 'package:flutter/material.dart';

class DatePickerHelper {
  factory DatePickerHelper() => _datePicker;
  DatePickerHelper._internal();
  static final DatePickerHelper _datePicker = DatePickerHelper._internal();

  static Future<DateTime?> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2050),
    );
    return pickedDate;
  }
}
