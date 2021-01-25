// This file declares functions that manages the asset database that is compiled with the app

import 'dart:io';
// This file declares functions that manages the asset database that is bundled in the app

import 'dart:async';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';

import 'package:katiba/models/record.dart';
import 'package:katiba/utils/constants.dart';

class SqliteAssets {
  static SqliteAssets sqliteHelper; // Singleton DatabaseHelper
  static Database appDb; // Singleton Database

  SqliteAssets._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory SqliteAssets() {
    if (sqliteHelper == null) {
      sqliteHelper = SqliteAssets._createInstance(); // This is executed only once, singleton object
    }
    return sqliteHelper;
  }

  Future<Database> get database async {
    if (appDb == null) {
      appDb = await initializeDatabase();
    }
    return appDb;
  }

  /// initialize the asset database
  Future<Database> initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "demo_asset_example.db");

    // Check if the database exists
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    // Copy from asset
    ByteData data = await rootBundle.load(join("assets", "katiba.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write and flush the bytes written
    await File(path).writeAsBytes(bytes, flush: true);

    // open the database
    var assetDatabase = await openDatabase(path, readOnly: true);
    return assetDatabase;
  }

  Future<List<Map<String, dynamic>>> getRecordMapList() async {
    Database db = await this.database;
    var result = db.query(LangStrings.recordsTable);
    return result;
  }

  Future<List<Record>> getRecordList() async {
    var recordMapList = await getRecordMapList();
    List<Record> recordList = List<Record>();
    for (int i = 0; i < recordMapList.length; i++) {
      recordList.add(Record.fromMapObject(recordMapList[i]));
    }
    return recordList;
  }

}
