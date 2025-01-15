import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:macros_app/databases/user_meals_db.dart' as db;
import 'package:macros_app/models/user_meal_model.dart';

class UserMealsNotifier extends StateNotifier<List<UserMeal>> {
  UserMealsNotifier() : super([]) {
    _loadUserMeals();
  }

  Future<void> _loadUserMeals() async {
    final data = await db.getUserMeals();
    state = data;
  }

  Future<void> addUserMeal(UserMeal newMeal) async {
    await db.insertUserMeal(newMeal);
    _loadUserMeals();
  }

  Future<void> updateUserMeal(UserMeal updatedMeal) async {
    await db.updateUserMeal(updatedMeal);
    _loadUserMeals();
  }

  Future<void> removeUserMeal(UserMeal deletedMeal) async {
    await db.deleteUserMeal(deletedMeal.id);
    _loadUserMeals();
  }
}

final userMealsProvider =
    StateNotifierProvider<UserMealsNotifier, List<UserMeal>>((ref) {
  return UserMealsNotifier();
});
