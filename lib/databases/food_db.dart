import 'dart:async';

import 'package:macros_app/constants/map_entries.dart';
import 'package:macros_app/constants/table_names.dart';
import 'package:sqflite/sqflite.dart';

import 'package:macros_app/databases/initialize_db.dart';
import 'package:macros_app/models/food_model.dart';

Future<List<Food>> getSavedFood() async {
  final db = await getDatabase();
  final List<Map<String, dynamic>> savedFoodMap =
      await db.query(kSavedFoodTable);
  late List<Food> sortedList;

  sortedList = [
    for (final {
          kIdKey: id as String,
          kFoodNameKey: foodName as String,
          kCaloriesKey: calories as double,
          kProteinKey: protein as double,
          kCarbsKey: carbs as double,
          kFatsKey: fats as double,
          kServingNameKey: serving as String,
          kServingQuantityKey: servingQuantity as double,
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
    kSavedFoodTable,
    newFood.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updatedSavedFood(Food updatedFood) async {
  final db = await getDatabase();

  await db.update(
    kSavedFoodTable,
    updatedFood.toMap(),
    where: 'id = ?',
    whereArgs: [updatedFood.id],
  );
}

Future<void> deleteSavedFood(String id) async {
  final db = await getDatabase();

  await db.delete(
    kSavedFoodTable,
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> deleteAllSavedFood() async {
  final db = await getDatabase();

  await db.delete(kSavedFoodTable);
}
