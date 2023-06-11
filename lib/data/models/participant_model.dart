import 'dart:convert';

ParticipantModel participantModelFromJson(String str) =>
    ParticipantModel.fromJson(json.decode(str));

String participantModelToJson(ParticipantModel data) =>
    json.encode(data.toJson());

class ParticipantModel {
  factory ParticipantModel.fromJson(Map<String, dynamic> json) =>
      ParticipantModel(
        id: json["id"] ?? 0,
        homeCode: json["homeCode"] ?? '',
        name: json["name"] ?? '',
        phonenumber: json["phonenumber"] ?? '',
        image: json["image"] ?? '',
        income: json["income"] ?? 0,
        isAdmin: json["isAdmin"] ?? 0,
        addedOn: json["addedOn"] != null
            ? DateTime.parse(json["addedOn"])
            : DateTime.now(),
      );
  ParticipantModel({
    required this.id,
    required this.homeCode,
    required this.name,
    required this.phonenumber,
    required this.image,
    required this.income,
    required this.isAdmin,
    required this.addedOn,
  });

  final int id;
  final String homeCode;
  final String name;
  final String phonenumber;
  final String image;
  final int income;
  final int isAdmin;
  final DateTime addedOn;

  ParticipantModel copyWith({
    int? id,
    String? homeCode,
    String? name,
    String? phonenumber,
    String? image,
    int? income,
    int? isAdmin,
    DateTime? addedOn,
  }) =>
      ParticipantModel(
        id: id ?? this.id,
        homeCode: homeCode ?? this.homeCode,
        name: name ?? this.name,
        phonenumber: phonenumber ?? this.phonenumber,
        image: image ?? this.image,
        income: income ?? this.income,
        isAdmin: isAdmin ?? this.isAdmin,
        addedOn: addedOn ?? this.addedOn,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "homeCode": homeCode,
        "name": name,
        "phonenumber": phonenumber,
        "image": image,
        "income": income,
        "isAdmin": isAdmin,
        "addedOn": addedOn.toIso8601String(),
      };
}
