import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:macros_app/databases/initialize_db.dart';

// TODO: potentially add a method to populate the days with an unset value as macro_goal_id.

Future<Map<String, dynamic>> getDayMacroGoals(
  int dayIndex,
) async {
  final db = await getDatabase();
  final List<Map<String, dynamic>> dayMacroGoals = await db.rawQuery(
    '''
  SELECT d.day, m.calories, m.protein, m.carbs, m.fats
  FROM daily_macro_goals d
  JOIN macro_goals m on d.macro_goal_id = m.id
  WHERE d.day = ?
  ''',
    [dayIndex],
  );

  if (dayMacroGoals.isNotEmpty) {
    return dayMacroGoals.first;
  } else {
    return {};
  }
}

Future<List<int>> getDaysForGoal(
  String id,
) async {
  final List<int> daysForGoal = [];
  final db = await getDatabase();
  final List<Map<String, dynamic>> dayMacroGoals = await db.rawQuery(
    '''
  SELECT d.day
  FROM daily_macro_goals d
  JOIN macro_goals m on d.macro_goal_id = m.id
  WHERE m.id = ?
  ''',
    [id],
  );

  if (dayMacroGoals.isNotEmpty) {
    for (var row in dayMacroGoals) {
      daysForGoal.add(row['day']);
    }
    return daysForGoal;
  } else {
    return [];
  }
}

Future<void> insertDayMacroGoal(int dayIndex, String macroGoalId) async {
  final db = await getDatabase();

  await db.insert(
    'daily_macro_goals',
    {
      'day': dayIndex,
      'macro_goal_id': macroGoalId,
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateDayMacroGoal(int dayIndex, String newMacroGoalId) async {
  final db = await getDatabase();

  await db.update(
    'daily_macro_goals',
    {
      'day': dayIndex,
      'macro_goal_id': newMacroGoalId,
    },
    where: 'day = ?',
    whereArgs: [dayIndex],
  );
}

Future<void> deleteDayMacroGoal(int dayIndex) async {
  final db = await getDatabase();

  await db.update(
    'daily_macro_goals',
    {
      'day': dayIndex,
      // If unset, a widget to add a macro goal will be shown.
      'macro_goal_id': 'unset',
    },
    where: 'day = ?',
    whereArgs: [dayIndex],
  );
}
