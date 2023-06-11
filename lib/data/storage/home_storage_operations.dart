import 'package:homeexpensecalculator/data/models/home_model.dart';
import 'package:homeexpensecalculator/data/storage/storage_operations.dart';
import 'package:sqflite/sqflite.dart';

class HomeStorageOperations {
  HomeStorageOperations._instance();
  factory HomeStorageOperations() => _singleton;
  static final HomeStorageOperations _singleton =
      HomeStorageOperations._instance();

  static Future<int?> addHome(HomeModel home) async {
    final Database db = await DatabaseOperations.db();
    final Map<String, dynamic> newHome = <String, dynamic>{
      'name': home.name,
      'code': home.code,
      'encryption': home.encryption,
      'startDate': home.startDate.toString(),
    };
    try {
      final int id = await db.insert('home', newHome,
          conflictAlgorithm: ConflictAlgorithm.replace);
      return id;
    } catch (_) {
      return null;
    }
  }

  static Future<int?> updateHome(HomeModel home) async {
    final Database db = await DatabaseOperations.db();
    final Map<String, dynamic> newHome = <String, dynamic>{
      'name': home.name,
      'code': home.code,
      'encryption': home.encryption,
      'startDate': home.startDate.toString(),
    };
    try {
      final int id = await db.update('home', newHome,
          where: "id = ?", whereArgs: <Object?>[home.id]);
      return id;
    } catch (_) {
      return null;
    }
  }
}
