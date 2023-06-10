import 'package:sqflite/sqflite.dart';

class DatabaseOperations {
  DatabaseOperations._instance();
  factory DatabaseOperations() => _singleton;
  static DatabaseOperations get _singleton => DatabaseOperations._instance();

  static Future<String> getExpensesDbPath() async {
// Get a location using getDatabasesPath
    final String databasesPath = await getDatabasesPath();
    final String path = '$databasesPath/homeExpensesCalculatorDatabase.db';
    return path;
  }

// create and open the database
  static Future<Database> db() async =>
      openDatabase(await getExpensesDbPath(), version: 1,
          onCreate: (Database db, int version) async {
        // ignore: always_specify_types
        await Future.wait([
          createHomeTable(db),
          createParticipantsTable(db),
          createExpensesTable(db),
          createSavingsTable(db),
        ]);
      });

  static Future<void> createHomeTable(Database db) async {
    await db.execute('''
CREATE TABLE home (
id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
name TEXT,
code TEXT,
encryption TEXT,
startDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)
''');
  }

  static Future<void> createParticipantsTable(Database db) async {
    await db.execute('''
CREATE TABLE participants (
id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
homeCode TEXT,
name TEXT,
phonenumber TEXT,
addedOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)
''');
  }

  static Future<void> createExpensesTable(Database db) async {
    await db.execute('''
CREATE TABLE expenses (
id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
type INTEGER NOT NULL,
name TEXT,
startDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
endDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
comment TEXT,
cost INTEGER)
''');
  }

  static Future<void> createSavingsTable(Database db) async {
    await db.execute('''
CREATE TABLE savings (
id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
type INTEGER NOT NULL,
name TEXT,
startDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
endDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
comment TEXT,
cost INTEGER)
''');
  }
}
