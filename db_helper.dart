import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Future<Database> get db async {
    return openDatabase(
      join(await getDatabasesPath(), 'mom_preduct.db'),
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            league TEXT NOT NULL,
            home TEXT NOT NULL,
            away TEXT NOT NULL,
            homeProb INTEGER NOT NULL,
            drawProb INTEGER NOT NULL,
            awayProb INTEGER NOT NULL,
            score TEXT NOT NULL,
            confidence TEXT NOT NULL,
            date TEXT NOT NULL
          )
        ''');
      },
    );
  }

  static Future<void> add(Map<String, dynamic> data) async {
    final database = await db;
    await database.insert('history', data);
  }

  static Future<List<Map<String, dynamic>>> getHistory() async {
    final database = await db;
    return database.query('history', orderBy: 'id DESC');
  }

  static Future<void> clear() async {
    final database = await db;
    await database.delete('history');
  }
}
