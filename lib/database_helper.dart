import 'dart:async';
import 'dart:io';

import 'package:database_intro/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableUser = "userTable";
  final String columnId  = "id";
  final String columnUserName = "username";
  final String columnPassword = "password";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  /*
  * id | username | password
  * ------------------------
  * 1  | Paulo    | paulo
  * 2  | James    | bond
  * */
  void _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE $tableUser($columnId INTEGER PRIMARY KEY, $columnUserName TEXT, $columnPassword TEXT)"
    );
  }

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "maindb.db"); // home://directory/files/maindb.db
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  // CRUD - CREATE, READ, UPDATE, DELETE
  // Insertion
  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert(tableUser, user.toMap());
    return res;
  }

  // Get Users
  Future<List> getAllUsers() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableUser");

    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
      await dbClient.rawQuery("SELECT COUNT(*) FROM $tableUser")
    );
  }

  Future<User> getUser(int id) async {
    var dbClient = await db;

    var result = await dbClient.rawQuery("SELECT * FROM $tableUser WHERE $columnId = $id");
    if (result.length == 0) return null;
    return User.fromMap(result.first);
  }

  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableUser,
        where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> updateUser(User user) async {
    var dbClient = await db;
    return await dbClient.update(tableUser, user.toMap(),
        where: "$columnId = ${user.id}", whereArgs: [user.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}