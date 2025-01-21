import 'dart:async';

import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/constants/table_names.dart';
import 'package:sqflite/sqflite.dart';

import 'package:macros_app/databases/initialize_db.dart';

// TODO: potentially add a method to populate the days with an unset value as macro_goal_id.

Future<Map<String, dynamic>> getDayMacroGoals(
  int dayIndex,
) async {
  final db = await getDatabase();
  final List<Map<String, dynamic>> dayMacroGoals = await db.rawQuery(
    '''
  SELECT d.$kDayKey, m.$kCaloriesKey, m.$kProteinKey, m.$kCarbsKey, m.$kFatsKey
  FROM $kDailyMacroGoalsTable d
  JOIN $kMacroGoalsTable m on d.$kMacroGoalIdKey = m.$kIdKey
  WHERE d.$kDayKey = ?
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
  SELECT d.$kDayKey
  FROM $kDailyMacroGoalsTable d
  JOIN $kMacroGoalsTable m on d.$kMacroGoalIdKey = m.$kIdKey
  WHERE m.$kIdKey = ?
  ''',
    [id],
  );

  if (dayMacroGoals.isNotEmpty) {
    for (var row in dayMacroGoals) {
      daysForGoal.add(row[kDayKey]);
    }
    return daysForGoal;
  } else {
    return [];
  }
}

Future<void> insertDayMacroGoal(int dayIndex, String macroGoalId) async {
  final db = await getDatabase();

  await db.insert(
    kDailyMacroGoalsTable,
    {
      kDayKey: dayIndex,
      kMacroGoalIdKey: macroGoalId,
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateDayMacroGoal(int dayIndex, String newMacroGoalId) async {
  final db = await getDatabase();

  await db.update(
    kDailyMacroGoalsTable,
    {
      kDayKey: dayIndex,
      kMacroGoalIdKey: newMacroGoalId,
    },
    where: '$kDayKey = ?',
    whereArgs: [dayIndex],
  );
}

Future<void> deleteDayMacroGoal(int dayIndex) async {
  final db = await getDatabase();

  await db.update(
    kDailyMacroGoalsTable,
    {
      kDayKey: dayIndex,
      // If unset, a widget to add a macro goal will be shown.
      kMacroGoalIdKey: 'unset',
    },
    where: '$kDayKey = ?',
    whereArgs: [dayIndex],
  );
}
