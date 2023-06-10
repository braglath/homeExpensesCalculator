import 'package:homeexpensecalculator/data/storage/individual_service_model_storage.dart';
import 'package:homeexpensecalculator/data/storage/storage_operations.dart';
import 'package:sqflite/sqflite.dart';

class ExpensesStorageOperations {
  ExpensesStorageOperations._instance();
  factory ExpensesStorageOperations() => _singleton;
  static final ExpensesStorageOperations _singleton =
      ExpensesStorageOperations._instance();

  static Future<int> addExpenses(IndividualServiceModel expense) async {
    final Database db = await DatabaseOperations.db();
    final Map<String, dynamic> expenses = <String, dynamic>{
      'type': expense.type,
      'name': expense.name,
      'startDate': expense.startDate.toString(),
      'endDate': expense.endDate.toString(),
      'comment': expense.comment,
      'cost': expense.cost
    };
    final int id = await db.insert('expenses', expenses,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<IndividualServiceModel>> getAllExpenses() async {
    final Database db = await DatabaseOperations.db();
    final List<Map<String, Object?>> valuesList =
        await db.query('expenses', orderBy: 'id');
    final List<IndividualServiceModel> expensesList =
        <IndividualServiceModel>[];
    for (Map<String, Object?> value in valuesList) {
      expensesList.add(IndividualServiceModel.fromJson(value));
    }
    return expensesList;
  }

  static Future<int> updateExpense(IndividualServiceModel expense) async {
    final Database db = await DatabaseOperations.db();
    final Map<String, dynamic> expenses = <String, dynamic>{
      'type': expense.type,
      'name': expense.name,
      'startDate': expense.startDate.toString(),
      'endDate': expense.endDate.toString(),
      'comment': expense.comment,
      'cost': expense.cost
    };
    final int id = await db.update('expenses', expenses,
        where: "id = ?", whereArgs: <Object?>[expense.id]);
    return id;
  }

  static Future<bool> deleteExpense(int id) async {
    final Database db = await DatabaseOperations.db();
    try {
      await db.delete('expenses', where: "id = ?", whereArgs: <Object?>[id]);
      return true;
    } catch (_) {
      return false;
    }
  }
}
