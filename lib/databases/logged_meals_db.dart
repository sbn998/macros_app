import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/constants/table_names.dart';
import 'package:macros_app/databases/initialize_db.dart';
import 'package:macros_app/models/logged_meal_model.dart';

Future<List<LoggedMeal>> getLoggedMeals(DateTime date) async {
  final Database db = await getDatabase();
  String formattedDate = DateFormat('yyyy/MM/dd').format(date);

  final result = await db.query(
    kLoggedMealsTable,
    where: 'day = ?',
    whereArgs: [formattedDate],
  );

  if (result.isEmpty) {
    return [];
  }

  final loggedMeals =
      jsonDecode(result.first[kLoggedMealsKey] as String) as List<dynamic>;

  return loggedMeals
      .map((loggedMeal) =>
          LoggedMeal.fromMap(loggedMeal as Map<String, dynamic>))
      .toList();
}

Future<List<DateTime>> getLoggedMealsForMonth(DateTime month) async {
  final Database db = await getDatabase();

  // First and final days of the argument's month.
  final DateTime startOfMonth = DateTime(month.year, month.month, 1);
  final DateTime endOfMonth = DateTime(month.year, month.month + 1, 0);

  final String formattedStartDate =
      DateFormat('yyyy/MM/dd').format(startOfMonth);
  final String formattedEndDate = DateFormat('yyyy/MM/dd').format(endOfMonth);

  final result = await db.query(
    kLoggedMealsTable,
    where: 'day BETWEEN ? and ?',
    whereArgs: [formattedStartDate, formattedEndDate],
  );

  if (result.isEmpty) {
    return [];
  }

  Set<DateTime> markedDates = {};

  for (var row in result) {
    DateTime date = DateFormat('yyyy/MM/dd').parse(row[kDayKey] as String);
    markedDates.add(date);
  }
  return markedDates.toList();
}

Future<void> insertLoggedMeal(DateTime date, LoggedMeal loggedMeal) async {
  final Database db = await getDatabase();
  String formattedDate = DateFormat('yyyy/MM/dd').format(date);

  final result = await db.query(
    kLoggedMealsTable,
    where: 'day = ?',
    whereArgs: [formattedDate],
  );

  List<dynamic> loggedMeals = [];

  if (result.isEmpty) {
    loggedMeals.add(loggedMeal.toMap());

    final newLoggedMealsJson = jsonEncode(loggedMeals);

    await db.insert(
      kLoggedMealsTable,
      {
        kDayKey: formattedDate,
        kLoggedMealsKey: newLoggedMealsJson,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    loggedMeals =
        jsonDecode(result.first[kLoggedMealsKey] as String) as List<dynamic>;
    loggedMeals.add(loggedMeal.toMap());

    final updatedLoggedMealsJson = jsonEncode(loggedMeals);

    await db.update(
      kLoggedMealsTable,
      {kLoggedMealsKey: updatedLoggedMealsJson},
      where: 'day = ?',
      whereArgs: [formattedDate],
    );
  }
}

Future<void> updateLoggedMeal(
  DateTime date,
  LoggedMeal updatedLoggedMeal,
) async {
  final Database db = await getDatabase();
  final String formattedDate = DateFormat('yyyy/MM/dd').format(date);

  final result = await db.query(
    kLoggedMealsTable,
    where: 'day = ?',
    whereArgs: [formattedDate],
  );

  if (result.isEmpty) {
    throw Exception('No meals found for the given day: $formattedDate');
  }

  List<dynamic> loggedMeals =
      jsonDecode(result.first[kLoggedMealsKey] as String) as List<dynamic>;

  for (int i = 0; i < loggedMeals.length; i++) {
    if (loggedMeals[i][kIdKey] == updatedLoggedMeal.id) {
      loggedMeals[i] = updatedLoggedMeal.toMap();
      break;
    }
  }

  final updatedLoggedMealsJson = jsonEncode(loggedMeals);

  await db.update(
    kLoggedMealsTable,
    {kLoggedMealsKey: updatedLoggedMealsJson},
    where: 'day = ?',
    whereArgs: [formattedDate],
  );
}

Future<void> removeLoggedMeal(
  DateTime date,
  String id,
) async {
  final Database db = await getDatabase();
  final String formattedDate = DateFormat('yyyy/MM/dd').format(date);

  final result = await db.query(
    kLoggedMealsTable,
    where: 'day = ?',
    whereArgs: [formattedDate],
  );

  if (result.isEmpty) {
    throw Exception('No meals found for the given day: $formattedDate');
  }

  List<dynamic> loggedMeals =
      jsonDecode(result.first[kLoggedMealsKey] as String) as List<dynamic>;

  loggedMeals =
      loggedMeals.where((loggedMeal) => loggedMeal[kIdKey] != id).toList();

  final updatedLoggedMealsJson = jsonEncode(loggedMeals);

  await db.update(
    kLoggedMealsTable,
    {kLoggedMealsKey: updatedLoggedMealsJson},
    where: 'day = ?',
    whereArgs: [formattedDate],
  );
}

Future<void> draggedMealsTransactionUpdate(
    DateTime date, LoggedMeal meal, LoggedMeal secondMeal) async {
  final Database db = await getDatabase();
  final String formattedDate = DateFormat('yyyy/MM/dd').format(date);

  await db.transaction((txn) async {
    final result = await txn.query(
      kLoggedMealsTable,
      where: 'day = ?',
      whereArgs: [formattedDate],
    );

    if (result.isEmpty) {
      throw Exception('No meals found for the given day: $formattedDate');
    }

    List<dynamic> loggedMeals =
        jsonDecode(result.first[kLoggedMealsKey] as String) as List<dynamic>;

    _updateMealInList(loggedMeals, meal);
    _updateMealInList(loggedMeals, secondMeal);

    String updatedMealsJson = jsonEncode(loggedMeals);

    await txn.update(
      kLoggedMealsTable,
      {kLoggedMealsKey: updatedMealsJson},
      where: 'day = ?',
      whereArgs: [formattedDate],
    );
  });
}

void _updateMealInList(List<dynamic> meals, LoggedMeal updatedMeal) {
  for (int i = 0; i < meals.length; i++) {
    if (meals[i][kIdKey] == updatedMeal.id) {
      meals[i] = updatedMeal.toMap();
      return;
    }
  }
}
