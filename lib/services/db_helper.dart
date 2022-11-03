import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user.dart';

class DataHelper {
  late Database db;

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}lsp.db';
    var itemDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return itemDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT,
      nama TEXT,
      password TEXT,
      nomorHp TEXT
      )
    ''');
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  //register User
  Future<bool> registerUser(User user) async {
    Database db = await initDb();
    //encrypt password
    user.password = hashPassword(user.password!);
    try {
      await db.insert(
        'users',
        user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  //auth users
  Future<bool> authUser(String username, String password) async {
    db = await initDb();
    password = hashPassword(password);
    var result = await db.rawQuery('''
      SELECT * FROM users WHERE username = '$username' AND password = '$password'
    ''');
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<User> fetchUser(String username, password) async {
    db = await initDb();
    password = hashPassword(password);
    var result = await db.rawQuery('''
      SELECT * FROM users WHERE username = '$username' AND password = '$password'
    ''');
    if (result.isNotEmpty) {
      return User.fromJson(result.first);
    } else {
      return User();
    }
  }

  //update password
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    db = await initDb();
    var result = await db.rawQuery(
        'SELECT * FROM users WHERE username = "user" AND password = "$oldPassword"');
    if (result.isNotEmpty) {
      await db.rawUpdate(
          'UPDATE users SET password = "$newPassword" WHERE username = "user"');
      return true;
    } else {
      return false;
    }
  }

  //Select Cashflow
  Future<List<User>> selectUser() async {
    Database db = await initDb();
    final List<Map<String, dynamic>> maps =
        await db.query('cashflow', orderBy: 'date');
    return List.generate(maps.length, (i) {
      return User();
    });
  }

  Future close() async {
    Database db = await initDb();
    db.close();
  }
}
