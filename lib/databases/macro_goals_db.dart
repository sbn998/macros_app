import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/constants/table_names.dart';
import 'package:macros_app/databases/initialize_db.dart';
import 'package:macros_app/models/macro_goal_model.dart';

Future<List<MacroGoal>> getMacroGoals() async {
  final db = await getDatabase();
  final List<Map<String, dynamic>> macroGoals = await db.query('macro_goals');

  return [
    for (final {
          kIdKey: id as String,
          kGoalNameKey: goalName as String,
          kCaloriesKey: calories as double,
          kProteinKey: protein as double,
          kCarbsKey: carbs as double,
          kFatsKey: fats as double,
        } in macroGoals)
      MacroGoal(
        id: id,
        goalName: goalName,
        calories: calories,
        protein: protein,
        carbs: carbs,
        fats: fats,
      ),
  ];
}

Future<void> insertMacroGoal(MacroGoal macroGoal) async {
  final db = await getDatabase();

  await db.insert(
    kMacroGoalsTable,
    macroGoal.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateMacroGoal(MacroGoal updatedMacroGoal) async {
  final db = await getDatabase();

  await db.update(
    kMacroGoalsTable,
    updatedMacroGoal.toMap(),
    where: 'id = ?',
    whereArgs: [updatedMacroGoal.id],
  );
}

Future<void> deleteMacroGoal(String id) async {
  final db = await getDatabase();

  await db.delete(
    kMacroGoalsTable,
    where: 'id = ?',
    whereArgs: [id],
  );
}
