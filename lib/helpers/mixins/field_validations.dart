import 'package:homeexpensecalculator/helpers/extensions/ext_on_string.dart';

mixin FieldValidationMixin {
  
  String? emptyValidation(String? value) {
    if (value.isNullOrEmpty || value!.trim().isEmpty) {
      return 'cannot be empty';
    }
    return null;
  }
}
