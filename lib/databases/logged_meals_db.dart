import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

import 'package:macros_app/databases/initialize_db.dart';
import 'package:macros_app/models/logged_meal_model.dart';

Future<List<LoggedMeal>> getLoggedMeals(DateTime date) async {
  final Database db = await getDatabase();
  String formattedDate = DateFormat('yyyy/MM/dd').format(date);

  final result = await db.query(
    'logged_meals',
    where: 'day = ?',
    whereArgs: [formattedDate],
  );

  if (result.isEmpty) {
    return [];
  }

  final loggedMeals =
      jsonDecode(result.first['logged_meals'] as String) as List<dynamic>;

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
    'logged_meals',
    where: 'day BETWEEN ? and ?',
    whereArgs: [formattedStartDate, formattedEndDate],
  );

  if (result.isEmpty) {
    return [];
  }

  Set<DateTime> markedDates = {};

  for (var row in result) {
    DateTime date = DateFormat('yyyy/MM/dd').parse(row['day'] as String);
    markedDates.add(date);
  }
  return markedDates.toList();
}

Future<void> insertLoggedMeal(DateTime date, LoggedMeal loggedMeal) async {
  final Database db = await getDatabase();
  String formattedDate = DateFormat('yyyy/MM/dd').format(date);

  final result = await db.query(
    'logged_meals',
    where: 'day = ?',
    whereArgs: [formattedDate],
  );

  List<dynamic> loggedMeals = [];

  if (result.isEmpty) {
    loggedMeals.add(loggedMeal.toMap());

    final newLoggedMealsJson = jsonEncode(loggedMeals);

    await db.insert(
      'logged_meals',
      {
        'day': formattedDate,
        'logged_meals': newLoggedMealsJson,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    loggedMeals =
        jsonDecode(result.first['logged_meals'] as String) as List<dynamic>;
    loggedMeals.add(loggedMeal.toMap());

    final updatedLoggedMealsJson = jsonEncode(loggedMeals);

    await db.update(
      'logged_meals',
      {'logged_meals': updatedLoggedMealsJson},
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
    'logged_meals',
    where: 'day = ?',
    whereArgs: [formattedDate],
  );

  if (result.isEmpty) {
    throw Exception('No meals found for the given day: $formattedDate');
  }

  List<dynamic> loggedMeals =
      jsonDecode(result.first['logged_meals'] as String) as List<dynamic>;

  for (int i = 0; i < loggedMeals.length; i++) {
    if (loggedMeals[i]['id'] == updatedLoggedMeal.id) {
      loggedMeals[i] = updatedLoggedMeal.toMap();
      break;
    }
  }

  final updatedLoggedMealsJson = jsonEncode(loggedMeals);

  await db.update(
    'logged_meals',
    {'logged_meals': updatedLoggedMealsJson},
    where: 'day = ?',
    whereArgs: [formattedDate],
  );
}

Future<void> removeLoggedMeal(
  DateTime date,
  String id,
) async {
  final Database db = await getDatabase();
  final String formattedDate = DateFormat('yyyy/MM//dd').format(date);

  final result = await db.query(
    'logged_meals',
    where: 'day = ?',
    whereArgs: [formattedDate],
  );

  if (result.isEmpty) {
    throw Exception('No meals found for the given day: $formattedDate');
  }

  List<dynamic> loggedMeals =
      jsonDecode(result.first['logged_meals'] as String) as List<dynamic>;

  loggedMeals = loggedMeals.where((loggedMeal) => loggedMeal.id != id).toList();

  final updatedLoggedMealsJson = jsonEncode(loggedMeals);

  await db.update(
    'logged_meals',
    {'logged_meals': updatedLoggedMealsJson},
    where: 'day = ?',
    whereArgs: [formattedDate],
  );
}
