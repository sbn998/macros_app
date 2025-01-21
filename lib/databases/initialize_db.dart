import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:macros_app/constants/table_names.dart';
import 'package:macros_app/constants/map_entries.dart';

Future<Database> getDatabase() async {
  final database = openDatabase(
    // join() ensures the path is correctly constructed for each platform.
    join(await getDatabasesPath(), kDatabaseName),
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE $kUserMealsTable($kIdKey TEXT PRIMARY KEY, $kMealNameKey TEXT)',
      );
      await db.execute(
        'CREATE TABLE $kSavedFoodTable($kIdKey TEXT PRIMARY KEY, $kFoodNameKey TEXT, $kCaloriesKey REAL, $kProteinKey REAL, $kCarbsKey REAL, $kFatsKey REAL, $kServingNameKey TEXT, $kServingQuantityKey REAL)',
      );
      await db.execute(
          'CREATE TABLE $kLoggedMealsTable($kDayKey TEXT PRIMARY KEY, $kLoggedMealsKey TEXT)');
      await db.execute(
          'CREATE TABLE $kMacroGoalsTable($kIdKey TEXT PRIMARY KEY, $kGoalNameKey TEXT, $kCaloriesKey REAL, $kProteinKey REAL, $kCarbsKey REAL, $kFatsKey REAL)');
      await db.execute(
          'CREATE TABLE $kDailyMacroGoalsTable($kDayKey INTEGER PRIMARY KEY, $kMacroGoalIdKey TEXT, FOREIGN KEY ($kMacroGoalIdKey) REFERENCES $kMacroGoalsKey ($kIdKey))');
    },
    version: 1,
  );
  return database;
}
