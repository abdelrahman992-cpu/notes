import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return db;
    } else {
      return _db;
    }
  }

  initialDb() async {
    var databasepath = await getDatabasesPath();
    String path = await join(databasepath, 'wael.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 4, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) async {
    print("upgrade on =============");
  }

  _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''     
CREATE TABLE "notes"(
  "id" INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT ,
  "title" TEXT NOT NULL,
  "note" TEXT NOT NULL,
  "color" TEXT NOT NULL
)

''');
    await batch.commit();
    print("create DB");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  mydeleteDatabase() async {
    String databasepath = await getDatabasesPath();
    String path = await join(databasepath, 'wael.db');
    await deleteDatabase(path);
  }
}
