import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/databases/food_db.dart' as db;
import 'package:macros_app/models/food_model.dart';

class SavedFoodNotifier extends StateNotifier<List<Food>> {
  SavedFoodNotifier() : super([]) {
    _loadSavedFood();
  }

  Future<void> _loadSavedFood() async {
    final data = await db.getSavedFood();
    state = data;
  }

  Future<void> addSavedFood(Food newFood) async {
    await db.insertSavedFood(newFood);
    _loadSavedFood();
  }

  Future<void> updateSavedFood(Food updatedFood) async {
    await db.updatedSavedFood(updatedFood);
    _loadSavedFood();
  }

  Future<void> removeSavedFood(String foodId) async {
    await db.deleteSavedFood(foodId);
    _loadSavedFood();
  }
}

final savedFoodProvider =
    StateNotifierProvider<SavedFoodNotifier, List<Food>>((ref) {
  return SavedFoodNotifier();
});
