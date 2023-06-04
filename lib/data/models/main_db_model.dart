import 'dart:convert';

MainDbModel mainDbModelFromJson(String str) =>
    MainDbModel.fromJson(json.decode(str));

String mainDbModelToJson(MainDbModel data) => json.encode(data.toJson());

class MainDbModel {
  MainDbModel({
    required this.house,
    required this.data,
  });
  final String house;
  final Data data;

  MainDbModel copyWith({
    String? house,
    Data? data,
  }) =>
      MainDbModel(
        house: house ?? this.house,
        data: data ?? this.data,
      );

  factory MainDbModel.fromJson(Map<String, dynamic> json) => MainDbModel(
        house: json["house"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "house": house,
        "data": data.toJson(),
      };
}

class Data {
  final Expenses expenses;
  final Expenses savings;

  Data({
    required this.expenses,
    required this.savings,
  });

  Data copyWith({
    Expenses? expenses,
    Expenses? savings,
  }) =>
      Data(
        expenses: expenses ?? this.expenses,
        savings: savings ?? this.savings,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        expenses: Expenses.fromJson(json["expenses"]),
        savings: Expenses.fromJson(json["savings"]),
      );

  Map<String, dynamic> toJson() => {
        "expenses": expenses.toJson(),
        "savings": savings.toJson(),
      };
}

class Expenses {
  Expenses({
    required this.services,
    required this.total,
  });
  final List<Service> services;
  final int total;

  Expenses copyWith({
    List<Service>? services,
    int? total,
  }) =>
      Expenses(
        services: services ?? this.services,
        total: total ?? this.total,
      );

  factory Expenses.fromJson(Map<String, dynamic> json) => Expenses(
        services: List<Service>.from(
            json["services"].map((x) => Service.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "services": List<dynamic>.from(services.map((x) => x.toJson())),
        "total": total,
      };
}

class Service {
  Service({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.amount,
  });

  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int amount;

  Service copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    int? amount,
  }) =>
      Service(
        id: id ?? this.id,
        name: name ?? this.name,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        amount: amount ?? this.amount,
      );

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "amount": amount,
      };
}
