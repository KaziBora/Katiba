// This file declares functions that manages the database that is created in the app
// when the app is installed for the first time

import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:katiba/models/record.dart';
import 'package:katiba/utils/constants.dart';

class SqliteHelper {
  static SqliteHelper sqliteHelper; // Singleton DatabaseHelper
  static Database appDb; // Singleton Database

  SqliteHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory SqliteHelper() {
    if (sqliteHelper == null) {
      sqliteHelper = SqliteHelper._createInstance(); // This is executed only once, singleton object
    }
    return sqliteHelper;
  }

  Future<Database> get database async {
    if (appDb == null) {
      appDb = await initializeDatabase();
    }
    return appDb;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory docsDirectory = await getApplicationDocumentsDirectory();
    String path = join(docsDirectory.path, "AppDatabase.db");

    // Open/create the database at a given path
    var vsbDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return vsbDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(Queries.createHistoryTable);
    await db.execute(Queries.createRecordsTable);
    await db.execute(Queries.createSearchesTable);
  }

  //QUERIES FOR RECORD
  Future<int> insertRecord(Record item) async {
    Database db = await this.database;
    item.isfav = item.views = 0;

    var result = await db.insert(LangStrings.recordsTable, item.toMap());
    return result;
  }

  //RECORD LISTS
  Future<List<Map<String, dynamic>>> getRecordMapList() async {
    Database db = await this.database;
    var result = db.query(LangStrings.recordsTable);
    return result;
  }

  Future<List<Record>> getRecordList() async {
    var itemMapList = await getRecordMapList();
    List<Record> itemList = List<Record>();
    for (int i = 0; i < itemMapList.length; i++) {
      itemList.add(Record.fromMapObject(itemMapList[i]));
    }
    return itemList;
  }

  Future<int> favouriteRecord(Record item, bool isFavorited) async {
    var db = await this.database;
    if (isFavorited) item.isfav = 1;
    else item.isfav = 0;
    var result = await db.rawUpdate('UPDATE ' + LangStrings.recordsTable +
        ' SET ' + LangStrings.isfav + '=' + item.isfav.toString() +
        ' WHERE ' + LangStrings.id + '=' + item.id.toString());
    return result;
  }

  //RECORD SEARCH
  Future<List<Map<String, dynamic>>> getRecordSearchMapList(String searchString, bool searchByTitle) async {
    Database db = await this.database;
    String sqlQuery = LangStrings.title + " LIKE '$searchString%'";

    if (!searchByTitle)
      sqlQuery = sqlQuery + " OR " + LangStrings.body + " LIKE '$searchString%'";

    var result = db.query(LangStrings.recordsTable, where: sqlQuery);
    return result;
  }

  Future<List<Record>> getRecordSearch(String searchString, bool searchByTitle) async {
    var itemMapList = await getRecordSearchMapList(searchString, searchByTitle);

    List<Record> itemList = List<Record>();
    // For loop to create a 'item List' from a 'Map List'
    for (int i = 0; i < itemMapList.length; i++) {
      itemList.add(Record.fromMapObject(itemMapList[i]));
    }
    return itemList;
  }

  //FAVOURITES LISTS
  Future<List<Map<String, dynamic>>> getFavoritesList() async {
    Database db = await this.database;
    var result = db.query(LangStrings.recordsTable, where: LangStrings.isfav + "=1");
    return result;
  }

  Future<List<Record>> getFavorites() async {
    var itemMapList = await getFavoritesList();

    List<Record> itemList = List<Record>();
    for (int i = 0; i < itemMapList.length; i++) {
      itemList.add(Record.fromMapObject(itemMapList[i]));
    }

    return itemList;
  }

  //FAVORITE SEARCH
  Future<List<Map<String, dynamic>>> getFavSearchMapList(
      String searchString) async {
    Database db = await this.database;
    String extraQuery = 'AND ' + LangStrings.isfav + "=1 ";
    String sqlQuery = LangStrings.title + ' LIKE "$searchString%" $extraQuery OR ' +
        LangStrings.body + ' LIKE "$searchString%" $extraQuery';

    var result = db.query(LangStrings.recordsTable, where: sqlQuery);
    return result;
  }

  Future<List<Record>> getFavSearch(String searchString) async {
    var itemMapList = await getFavSearchMapList(searchString);

    List<Record> itemList = List<Record>();
    // For loop to create a 'item List' from a 'Map List'
    for (int i = 0; i < itemMapList.length; i++) {
      itemList.add(Record.fromMapObject(itemMapList[i]));
    }
    return itemList;
  }

}
