import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/databases/logged_meals_db.dart' as db;
import 'package:macros_app/models/logged_meal_model.dart';

class LoggedMealsNotifier extends StateNotifier<List<LoggedMeal>> {
  DateTime date;

  LoggedMealsNotifier(this.date) : super([]) {
    _loadLoggedMeals(date);
  }

  Future<void> _loadLoggedMeals(DateTime date) async {
    final data = await db.getLoggedMeals(date);
    state = data;
  }

  Future<void> addLoggedMeal(DateTime date, LoggedMeal meal) async {
    await db.insertLoggedMeal(date, meal);
    _loadLoggedMeals(date);
  }

  Future<void> updateLoggedMeal(DateTime date, LoggedMeal meal) async {
    await db.updateLoggedMeal(date, meal);
    _loadLoggedMeals(date);
  }

  Future<void> removeLoggedMeal(DateTime date, String id) async {
    await db.removeLoggedMeal(date, id);
    _loadLoggedMeals(date);
  }
}

final loggedMealsProvider = StateNotifierProvider.family<LoggedMealsNotifier,
    List<LoggedMeal>, DateTime>((ref, date) {
  return LoggedMealsNotifier(date);
});
