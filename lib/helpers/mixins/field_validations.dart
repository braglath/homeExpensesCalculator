import 'package:homeexpensecalculator/data/models/individual_service_model.dart';
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

  String? checkServiceAlreadyExists(
      String? serviceTitle, List<IndividualServiceModel> list) {
    if (serviceTitle.isNullOrEmpty || serviceTitle!.trim().isEmpty) {
      return 'cannot be empty';
    }
    final String val = serviceTitle.trim();
    if (val.length < 4) {
      return "more than 4";
    }

    final List<IndividualServiceModel> foundService = list
        .where((IndividualServiceModel service) => service.name == serviceTitle)
        .toList();
    if (foundService.isEmpty) return null;
    return 'already exists';
  }
}
