import 'package:sqflite/sqflite.dart';

import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/constants/table_names.dart';
import 'package:macros_app/databases/initialize_db.dart';
import 'package:macros_app/models/user_meal_model.dart';

Future<List<UserMeal>> getUserMeals() async {
  final db = await getDatabase();
  final List<Map<String, dynamic>> userMealsMap =
      await db.query(kUserMealsTable);

  return [
    for (final {
          kIdKey: id as String,
          kMealNameKey: mealName as String,
        } in userMealsMap)
      UserMeal(id: id, mealName: mealName),
  ];
}

Future<void> insertUserMeal(UserMeal meal) async {
  final db = await getDatabase();

  await db.insert(
    kUserMealsTable,
    meal.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateUserMeal(UserMeal meal) async {
  final db = await getDatabase();

  await db.update(
    kUserMealsTable,
    meal.toMap(),
    where: 'id = ?',
    whereArgs: [meal.id],
  );
}

Future<void> deleteUserMeal(String id) async {
  final db = await getDatabase();

  await db.delete(
    kUserMealsTable,
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> deleteAllUserMeals() async {
  final db = await getDatabase();

  await db.delete(kUserMealsTable);
}
