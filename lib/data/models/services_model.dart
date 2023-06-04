import 'package:homeexpensecalculator/utils/app_enum.dart';

class ServicesModel {
  ServicesModel({
    required this.serviceType,
    required this.name,
    required this.cost,
    required this.startDate,
    required this.endDate,
    required this.comment,
  });
  ServiceType serviceType;
  String name;
  int cost;
  DateTime startDate;
  DateTime endDate;
  String comment;
}
