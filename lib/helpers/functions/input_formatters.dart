import 'package:flutter/services.dart';

class OnlyNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
          .formatEditUpdate(oldValue, newValue);
}
