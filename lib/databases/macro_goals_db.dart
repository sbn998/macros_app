import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:macros_app/databases/initialize_db.dart';
import 'package:macros_app/models/macro_goal_model.dart';

Future<List<MacroGoal>> getMacroGoals() async {
  final db = await getDatabase();
  final List<Map<String, dynamic>> macroGoals = await db.query('macro_goals');

  return [
    for (final {
          'id': id as String,
          'goal_name': goalName as String,
          'calories': calories as double,
          'protein': protein as double,
          'carbs': carbs as double,
          'fats': fats as double,
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
    'macro_goals',
    macroGoal.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateMacroGoal(MacroGoal updatedMacroGoal) async {
  final db = await getDatabase();

  await db.update(
    'macro_goals',
    updatedMacroGoal.toMap(),
    where: 'id = ?',
    whereArgs: [updatedMacroGoal.id],
  );
}

Future<void> deleteMacroGoal(String id) async {
  final db = await getDatabase();

  await db.delete(
    'macro_goals',
    where: 'id = ?',
    whereArgs: [id],
  );
}
