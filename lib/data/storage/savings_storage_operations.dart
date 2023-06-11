import 'package:homeexpensecalculator/data/models/individual_service_model.dart';
import 'package:homeexpensecalculator/data/storage/storage_operations.dart';
import 'package:sqflite/sqflite.dart';

class SavingsStorageOperations {
  SavingsStorageOperations._instance();
  factory SavingsStorageOperations() => _singleton;
  static final SavingsStorageOperations _singleton =
      SavingsStorageOperations._instance();

  static Future<List<IndividualServiceModel>> getAllSavings() async {
    final Database db = await DatabaseOperations.db();
    final List<Map<String, Object?>> valuesList =
        await db.query('savings', orderBy: 'id DESC');
    final List<IndividualServiceModel> expensesList =
        <IndividualServiceModel>[];
    for (Map<String, Object?> value in valuesList) {
      expensesList.add(IndividualServiceModel.fromJson(value));
    }
    return expensesList;
  }

  static Future<int> addSaving(IndividualServiceModel saving) async {
    final Database db = await DatabaseOperations.db();
    final Map<String, dynamic> newSaving = <String, dynamic>{
      'type': saving.type,
      'name': saving.name,
      'startDate': saving.startDate.toString(),
      'endDate': saving.endDate.toString(),
      'comment': saving.comment,
      'cost': saving.cost
    };
    final int id = await db.insert('savings', newSaving,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> updateSavings(IndividualServiceModel saving) async {
    final Database db = await DatabaseOperations.db();
    final Map<String, dynamic> newSaving = <String, dynamic>{
      'type': saving.type,
      'name': saving.name,
      'startDate': saving.startDate.toString(),
      'endDate': saving.endDate.toString(),
      'comment': saving.comment,
      'cost': saving.cost
    };
    final int id = await db.update('savings', newSaving,
        where: "id = ?", whereArgs: <Object?>[saving.id]);
    return id;
  }

  static Future<bool> deleteSaving(int id) async {
    final Database db = await DatabaseOperations.db();
    try {
      await db.delete('savings', where: "id = ?", whereArgs: <Object?>[id]);
      return true;
    } catch (_) {
      return false;
    }
  }
}
