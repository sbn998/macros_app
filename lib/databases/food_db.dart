import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:macros_app/databases/initialize_db.dart';
import 'package:macros_app/models/food_model.dart';

Future<List<Food>> getSavedFood() async {
  final db = await getDatabase();
  final List<Map<String, dynamic>> savedFoodMap = await db.query('saved_food');
  late List<Food> sortedList;

  sortedList = [
    for (final {
          'id': id as String,
          'food_name': foodName as String,
          'calories': calories as double,
          'protein': protein as double,
          'carbs': carbs as double,
          'fats': fats as double,
          'serving': serving as String,
          'serving_quantity': servingQuantity as double,
        } in savedFoodMap)
      Food(
        id: id,
        foodName: foodName,
        calories: calories,
        protein: protein,
        carbs: carbs,
        fats: fats,
        serving: serving,
        servingQuantity: servingQuantity,
      ),
  ];

  sortedList.sort((a, b) => a.foodName.compareTo(b.foodName));

  return sortedList;
}

Future<void> insertSavedFood(Food newFood) async {
  final db = await getDatabase();

  await db.insert(
    'saved_food',
    newFood.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updatedSavedFood(Food updatedFood) async {
  final db = await getDatabase();

  await db.update(
    'saved_food',
    updatedFood.toMap(),
    where: 'id = ?',
    whereArgs: [updatedFood.id],
  );
}

Future<void> deleteSavedFood(String id) async {
  final db = await getDatabase();

  await db.delete(
    'saved_food',
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> deleteAllSavedFood() async {
  final db = await getDatabase();

  await db.delete('saved_food');
}
