import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  final database = openDatabase(
    // join() ensures the path is correctly constructed for each platform.
    join(await getDatabasesPath(), 'macros_app.db'),
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE user_meals(id TEXT PRIMARY KEY, meal_name TEXT)',
      );
      await db.execute(
        'CREATE TABLE saved_food(id TEXT PRIMARY KEY, food_name TEXT, calories REAL, protein REAL, carbs REAL, fats REAL, serving TEXT, serving_quantity REAL)',
      );
      await db.execute(
          'CREATE TABLE logged_meals(day TEXT PRIMARY KEY, logged_meals TEXT)');
      await db.execute(
          'CREATE TABLE macro_goals(id TEXT PRIMARY KEY, goal_name TEXT, calories REAL, protein REAL, carbs REAL, fats REAL)');
      await db.execute(
          'CREATE TABLE daily_macro_goals(day INTEGER PRIMARY KEY, macro_goal_id TEXT, FOREIGN KEY (macro_goal_id) REFERENCES macro_goals (id))');
    },
    version: 1,
  );
  return database;
}
