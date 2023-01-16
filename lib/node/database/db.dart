import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

class DBHelper {
  static const nodeTable = 'node';
  static const _db = 'ostrich.db';

  static Future<Database> database() async {
    Map<String, String> envVars = Platform.environment;
    var home = envVars['UserProfile'].toString();
    //没有文件夹则创建文件夹
    Directory dir = Directory(home + "/.ostrichConfig");
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final dbPath = join(dir.path, _db);

    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI

      sqfliteFfiInit();

      var databaseFactory = databaseFactoryFfi;
      var db = await databaseFactory.openDatabase(dbPath);

/*       final String ip;
      final String host;
      final String passwd;
      final int port;
      final String country;
      final String city; */

      await db
          .execute("CREATE TABLE IF NOT EXISTS $nodeTable(id TEXT PRIMARY KEY ,"
              " ip TEXT,"
              " host TEXT,"
              " passwd TEXT,"
              " port INTEGER,"
              " current INTEGER,"
              " country TEXT,"
              " city TEXT)");
      return db;
    }

    return await openDatabase(
      dbPath,
      onCreate: (db, version) {
        db.execute("CREATE TABLE IF NOT EXISTS $nodeTable(id TEXT PRIMARY KEY ,"
            " ip TEXT,"
            " host TEXT,"
            " passwd TEXT,"
            " port INTEGER,"
            " current INTEGER,"
            " country TEXT,"
            " city TEXT)");
      },
      version: 1,
    );
  }

  static Future<List<Map<String, dynamic>>> selectAll(String table) async {
    final db = await DBHelper.database();

    return db.query(table);
    // with Query
    // return db.rawQuery("SELECT * FROM $node");
  }

  static Future insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();

    return db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future update(
    String tableName,
    String columnName,
    String value,
    String id,
  ) async {
    final db = await DBHelper.database();

    return db.update(
      tableName,
      {columnName: value},
      where: 'id = ? ',
      whereArgs: [id],
    );
  }

  static Future deleteById(
    String tableName,
    String columnName,
    String id,
  ) async {
    final db = await DBHelper.database();

    return db.delete(
      tableName,
      where: '$columnName = ?',
      whereArgs: [id],
    );
  }

  static Future deleteTable(String tableName) async {
    final db = await DBHelper.database();

    return db.rawQuery('DELETE FROM $tableName');
  }
}
