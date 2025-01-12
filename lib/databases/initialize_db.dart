import 'dart:async';

import 'package:macros_app/constants/map_entries.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  final database = openDatabase(
    // join() ensures the path is correctly constructed for each platform.
    join(await getDatabasesPath(), 'macros_app.db'),
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE user_meals($kIdKey TEXT PRIMARY KEY, meal_name TEXT)',
      );
      await db.execute(
        'CREATE TABLE saved_food($kIdKey TEXT PRIMARY KEY, $kFoodNameKey TEXT, $kCaloriesKey REAL, $kProteinKey REAL, $kCarbsKey REAL, $kFatsKey REAL, $kServingNameKey TEXT, $kServingQuantityKey REAL)',
      );
      await db.execute(
          'CREATE TABLE logged_meals(day TEXT PRIMARY KEY, logged_meals TEXT)');
      await db.execute(
          'CREATE TABLE macro_goals($kIdKey TEXT PRIMARY KEY, goal_name TEXT, $kCaloriesKey REAL, $kProteinKey REAL, $kCarbsKey REAL, $kFatsKey REAL)');
      await db.execute(
          'CREATE TABLE daily_macro_goals(day INTEGER PRIMARY KEY, macro_goal_id TEXT, FOREIGN KEY (macro_goal_id) REFERENCES macro_goals (id))');
    },
    version: 1,
  );
  return database;
}
