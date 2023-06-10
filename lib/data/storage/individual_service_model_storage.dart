import 'dart:convert';

IndividualServiceModel individualServiceModelFromJson(String str) =>
    IndividualServiceModel.fromJson(json.decode(str));

String individualServiceModelToJson(IndividualServiceModel data) =>
    json.encode(data.toJson());

class IndividualServiceModel {
  factory IndividualServiceModel.fromJson(Map<String, dynamic> json) =>
      IndividualServiceModel(
        id: json["id"] ?? 0,
        type: json["type"] ?? 0,
        name: json["name"] ?? '',
        startDate: json["startDate"] != null
            ? DateTime.parse(json["startDate"])
            : DateTime.now(),
        endDate: json["endate"] != null
            ? DateTime.parse(json["endate"])
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
    this.id,
  });
  final int? id;
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
        id: id ?? 0,
        type: type ?? this.type,
        name: name ?? this.name,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        comment: comment ?? this.comment,
        cost: cost ?? this.cost,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "type": type,
        "name": name,
        "startDate":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "endate":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "comment": comment,
        "cost": cost,
      };
}
