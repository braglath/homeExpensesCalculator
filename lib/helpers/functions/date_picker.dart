import 'package:flutter/material.dart';

class DatePickerHelper {
  factory DatePickerHelper() => _datePicker;
  DatePickerHelper._internal();
  static final DatePickerHelper _datePicker = DatePickerHelper._internal();

  static Future<DateTime?> selectDate(BuildContext context,
      [DateTime? firstDate]) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: firstDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2019),
      lastDate: DateTime(2050),
    );
    return pickedDate;
  }
}
