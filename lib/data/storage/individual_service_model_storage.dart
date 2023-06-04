import 'dart:convert';

IndividualServiceModel individualServiceModelFromJson(String str) =>
    IndividualServiceModel.fromJson(json.decode(str));

String individualServiceModelToJson(IndividualServiceModel data) =>
    json.encode(data.toJson());

class IndividualServiceModel {
  factory IndividualServiceModel.fromJson(Map<String, dynamic> json) =>
      IndividualServiceModel(
        type: json["type"] ?? 0,
        name: json["name"] ?? '',
        startDate: json["start_date"] != null
            ? DateTime.parse(json["start_date"])
            : DateTime.now(),
        endDate: json["end_date"] != null
            ? DateTime.parse(json["end_date"])
            : DateTime.now(),
        comment: json["comment"] ?? '',
        cost: json["cost"] ?? 0,
      );

  IndividualServiceModel({
    required this.type,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.comment,
    required this.cost,
  });

  final int type;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String comment;
  final int cost;

  IndividualServiceModel copyWith({
    int? type,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    String? comment,
    int? cost,
  }) =>
      IndividualServiceModel(
        type: type ?? this.type,
        name: name ?? this.name,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        comment: comment ?? this.comment,
        cost: cost ?? this.cost,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "type": type,
        "name": name,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "comment": comment,
        "cost": cost,
      };
}
