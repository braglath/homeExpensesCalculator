import 'package:sqflite/sqflite.dart';

class ExpensesStorageOperations {
  Future<String> getExpensesDbPath() async {
// Get a location using getDatabasesPath
    final String databasesPath = await getDatabasesPath();
    final String path = '$databasesPath/expenses.db';
    return path;
  }

// Delete the database
// await deleteDatabase(path);

// create and open the database
  Future<void> createTable(String dbPath) async {
    Database database = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute('''
CREATE TABLE Expenses (
id INTEGER PRIMARY KEY AUTOINCREMENT ,
name TEXT,
startDate TEXT,
endDate TEXT,
comment TEXT,
cost INTEGER)
''');
    });
  }
// // Insert some records in a transaction
// await database.transaction((txn) async {
//   int id1 = await txn.rawInsert(
//       'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
//   print('inserted1: $id1');
//   int id2 = await txn.rawInsert(
//       'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
//       ['another name', 12345678, 3.1416]);
//   print('inserted2: $id2');
// });

// // Update some record
// int count = await database.rawUpdate(
//     'UPDATE Test SET name = ?, value = ? WHERE name = ?',
//     ['updated name', '9876', 'some name']);
// print('updated: $count');

// // Get the records
// List<Map> list = await database.rawQuery('SELECT * FROM Test');
// List<Map> expectedList = [
//   {'name': 'updated name', 'id': 1, 'value': 9876, 'num': 456.789},
//   {'name': 'another name', 'id': 2, 'value': 12345678, 'num': 3.1416}
// ];
// print(list);
// print(expectedList);
// assert(const DeepCollectionEquality().equals(list, expectedList));

// // Count the records
// count = Sqflite
//     .firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM Test'));
// assert(count == 2);

// // Delete a record
// count = await database
//     .rawDelete('DELETE FROM Test WHERE name = ?', ['another name']);
// assert(count == 1);

// // Close the database
// await database.close();
}
