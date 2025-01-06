import 'package:sqflite/sqflite.dart';

import 'package:macros_app/databases/initialize_db.dart';
import 'package:macros_app/models/user_meal_model.dart';

Future<List<UserMeal>> getUserMeals() async {
  final db = await getDatabase();
  final List<Map<String, dynamic>> userMealsMap = await db.query('user_meals');

  return [
    for (final {
          'id': id as String,
          'meal_name': mealName as String,
        } in userMealsMap)
      UserMeal(id: id, mealName: mealName),
  ];
}

Future<void> insertUserMeal(UserMeal meal) async {
  final db = await getDatabase();

  await db.insert(
    'user_meals',
    meal.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateUserMeal(UserMeal meal) async {
  final db = await getDatabase();

  await db.update(
    'user_meals',
    meal.toMap(),
    where: 'id = ?',
    whereArgs: [meal.id],
  );
}

Future<void> deleteUserMeal(String id) async {
  final db = await getDatabase();

  await db.delete('user_meals', where: 'id = ?', whereArgs: [id]);
}

Future<void> deleteAllUserMeals() async {
  final db = await getDatabase();

  await db.delete('user_meals');
}
