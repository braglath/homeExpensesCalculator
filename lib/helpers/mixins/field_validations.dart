import 'package:homeexpensecalculator/helpers/extensions/ext_on_string.dart';

mixin FieldValidationMixin {
  String? emptyValidation(String? value) {
    if (value.isNullOrEmpty || value!.trim().isEmpty) {
      return 'cannot be empty';
    }
    return null;
  }

  String? homeTitleValidation(String? value) {
    if (value.isNullOrEmpty || value!.trim().isEmpty) {
      return 'cannot be empty';
    }
    final String val = value.trim();
    if (val.length < 4) {
      return "more than 4";
    }
    return null;
  }
}
