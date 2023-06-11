import 'dart:convert';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        code: json["code"] ?? '',
        encryption: json["encryption"] ?? '',
        startDate: json["startDate"] != null
            ? DateTime.parse(json["startDate"])
            : DateTime.now(),
      );

  HomeModel({
    required this.name,
    required this.code,
    required this.encryption,
    required this.startDate,
    this.id,
  });
  final int? id;
  final String name;
  final String code;
  final String encryption;
  final DateTime startDate;

  HomeModel copyWith({
    int? id,
    String? name,
    String? code,
    String? encryption,
    DateTime? startDate,
  }) =>
      HomeModel(
        id: id ?? this.id,
        name: name ?? this.name,
        code: code ?? this.code,
        encryption: encryption ?? this.encryption,
        startDate: startDate ?? this.startDate,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "name": name,
        "code": code,
        "encryption": encryption,
        "startDate": startDate.toIso8601String(),
      };
}
